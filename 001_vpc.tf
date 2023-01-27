module "vpc-1" {

  source = "github.com/dkumar-p/terraform-aws-vpc.git?ref=v3.19.0"


  name                 = var.name_vpc_cluster
  cidr                 = var.vpc_cidr_cluster
  enable_dns_hostnames = true
  enable_dns_support   = true


  enable_ipv6 = false

  enable_nat_gateway = false
  single_nat_gateway = false

  azs             = var.vpc_azs
  public_subnets  = var.vpc_public_subnets_cluster
  private_subnets = var.vpc_private_subnets_cluster

  manage_default_security_group  = true
  default_security_group_ingress = [{}]
  default_security_group_egress  = [{}]

  tags = merge(var.tags,
    {
      "resource:name" = var.name_vpc_cluster
    }
  )
}

#Security group for end points

resource "aws_security_group" "allow_tls" {
  name        = "allow_tls"
  description = "Allow TLS inbound traffic"
  vpc_id      = module.vpc-1.vpc_id
  ingress {
    description = "TLS from VPC"
    from_port   = 443
    to_port     = 443
    protocol    = "tcp"
    cidr_blocks = ["0.0.0.0/0"]
  }
  egress {
    from_port        = 0
    to_port          = 0
    protocol         = "-1"
    cidr_blocks      = ["0.0.0.0/0"]
    ipv6_cidr_blocks = ["::/0"]
  }
  tags = merge(var.tags, {
    Name = "${var.name_vpc_cluster}_endpoint-security_group"
    }
  )
}

