[settings.kubernetes]
"cluster-name" = "${cluster_name}"
"api-server" = "${cluster_endpoint}"
"cluster-certificate" = "${cluster_ca_base64}"
"max-pods" = 110

[settings.kernel]
"lockdown" = "integrity"

[settings.kubernetes.node-labels]
"eks.amazonaws.com/capacityType" = "${capacity}"