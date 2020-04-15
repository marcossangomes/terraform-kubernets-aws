This is an example for you to use when importing this module:

module "sg-rule-mc" {
  source = "./modules/sg-rule"
  
  description                    = "Allow workstation to communicate with the cluster API Server"
  from_port                      = 443
  to_port                        = 443
  protocol                       = "tcp"
  security_group_demo_cluster_id = aws_security_group.demo-cluster.id
  security_group_demo_node_id    = aws_security_group.demo-cluster.id
  type                           = "ingress"

}