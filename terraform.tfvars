tags = {
  "company"     = "my Project-test-pavan"
  "environment" = "int"
}

### VPC Details =========================================
name_vpc_cluster = "Devops-test-vpc-1"
vpc_cidr_cluster = "10.98.20.0/25"

vpc_public_subnets_cluster  = ["10.98.20.0/28", "10.98.20.16/28"]
vpc_private_subnets_cluster = ["10.98.20.32/28", "10.98.20.48/28", "10.98.20.64/28", "10.98.20.80/28"]


### EC2 Details =========================================

ami_master    = "ami-01a4f99c4ac11b03c"
instance_type = "t2.micro"
key_name      = "devops-test-1"