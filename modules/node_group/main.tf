locals {
  launch_template_name = "bottlerocket-eks-node-group"
  node_group_name      = "bottlerocket-eks-node-group"
  iam_role_name        = "bottlerocket-eks-node"
  node_sg_name         = "bottlerocket-eks-node"
  user_data = templatefile("${path.module}/templates/userdata.tpl",
    {
        cluster_name         = var.cluster_name
        cluster_endpoint     = var.cluster_endpoint
        cluster_ca_base64    = var.cluster_auth_base64
        capacity             = var.capacity_type
    }
  )
  tags = {
    Example    = var.cluster_name
  }
}

resource "aws_launch_template" "launch_template" {
  name                   = local.launch_template_name
  image_id               = data.aws_ami.bottlerocket_ami.id
  user_data              = base64encode(local.user_data)
  vpc_security_group_ids = [aws_security_group.node.id]

  lifecycle {
    create_before_destroy = true
  }

  dynamic "tag_specifications" {
    for_each = toset(["instance", "volume", "network-interface", "spot-instances-request"])
    content {
      resource_type = tag_specifications.key
      tags          = merge(local.tags, { Name = local.launch_template_name })
    }
  }

  tags = merge(
    local.tags,
    { Name = local.launch_template_name }
  )
}

resource "aws_eks_node_group" "node_group" {
  cluster_name    = var.cluster_name
  node_group_name_prefix = "${local.node_group_name}-"
  node_role_arn   = aws_iam_role.this.arn
  subnet_ids      = var.subnet_ids
  capacity_type   = var.capacity_type
  instance_types  = var.instance_types

  launch_template {
    id      = aws_launch_template.launch_template.id
    version = aws_launch_template.launch_template.latest_version
  }

  scaling_config {
    desired_size = var.desired_size
    max_size     = var.max_nodes
    min_size     = var.min_nodes
  }

  lifecycle {
    create_before_destroy = true
    ignore_changes = [
      scaling_config[0].desired_size
    ]
  }

  tags = merge(
    local.tags,
    { Name = local.node_group_name }
  )
}
