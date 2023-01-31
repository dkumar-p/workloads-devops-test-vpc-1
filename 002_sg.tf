locals {
  name_sg_1 = "Devops_test_1_SG"
}

module "security_group_ec2" {

  source = "github.com/dkumar-p/terraform-aws-security-group.git?ref=v4.7.0"

  name        = local.name_sg_1
  description = "Security group for usage with EC2 instance"
  vpc_id      = module.vpc-1.vpc_id

  ingress_cidr_blocks = ["0.0.0.0/0"]
  ingress_rules       = ["ssh-tcp"]

  egress_rules = ["all-all"]

  tags = merge(var.tags,
    {
      "ib:resource:name" = local.name_sg_1
    },
    {
      "Name" = local.name_sg_1
    }
  )
}

/*
resource "aws_security_group_rule" "controlm_int_instance1_portICMP" {
  provider          = aws.intcontrolm
  type              = "ingress"
  from_port         = -1
  to_port           = -1
  protocol          = "icmp"
  description       = "Rule ICMP"
  cidr_blocks       = ["10.98.100.0/24", "10.27.32.0/21", "10.4.0.0/21", "172.0.0.0/8", "55.132.0.0/22", "55.132.4.0/22"]
  security_group_id = module.security_group_ec2.security_group_id
}
*/