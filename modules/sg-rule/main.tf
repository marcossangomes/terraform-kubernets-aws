# OPTIONAL: Allow inbound traffic from your local workstation external IP to the Kubernetes.
# You will need to replace A.B.C.D below with your real IP.
# Services like icanhazip.com can help you find this.
resource "aws_security_group_rule" "demo-cluster-ingress-workstation-https" {
  # cidr_blocks              = var.cidr_block #["179.187.179.236/32"]
  description              = var.description
  from_port                = var.from_port
  protocol                 = var.protocol
  security_group_id        = var.security_group_demo_node_id
  source_security_group_id = var.security_group_demo_cluster_id
  to_port                  = var.to_port
  type                     = var.type
}
