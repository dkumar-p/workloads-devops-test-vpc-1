locals {
  ec2_name_1 = "Devops_test_1_EC2"
}

module "ec2_instance_1" {

  source = "github.com/dkumar-p/terraform-aws-ec2-instance.git?ref=v3.3.0"

  name = local.ec2_name_1

  ami                    = var.ami_master
  instance_type          = var.instance_type
  key_name               = var.key_name
  monitoring             = false
  vpc_security_group_ids = [module.security_group_ec2.security_group_id]
  subnet_id              = element(module.vpc-1.public_subnets, 0)
  enable_volume_tags     = false

  root_block_device = [
    {
      device_name           = "/dev/sda1"
      volume_size           = "40"
      volume_type           = "gp3"
      encrypted             = true
      delete_on_termination = false
      tags = merge(var.tags,
        {
          "resource:name" = local.ec2_name_1
        },
        {
          "Name" = local.ec2_name_1
        }
      )
    }
  ]
  
  
  user_data = "${file("015_userdata.sh")}"

  tags = merge(var.tags,
    {
      "resource:name" = local.ec2_name_1
      "Name"          = local.ec2_name_1
    }
  )
}
