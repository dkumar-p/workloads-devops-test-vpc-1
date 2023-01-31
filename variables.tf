variable "tags" {
  description = "A map of tags to add to all resources"
  type        = map(any)
}

variable "vpc_azs" {
  description = "List AZS for Subnets"
  type        = list(string)
  default     = ["ap-south-1a", "ap-south-1b"]
}

## VPC ACCOUNT------------------------------------------------------------------
variable "name_vpc_cluster" {
  description = "Vpc name for account"
  type        = string
  default     = ""
}

variable "vpc_cidr_cluster" {
  description = "Vpc CIDR for Account"
  type        = string
  default     = ""
}

variable "vpc_private_subnets_cluster" {
  description = "List private subnets for Account"
  type        = list(string)
  default     = []
}

variable "vpc_public_subnets_cluster" {
  description = "List public subnets for Account"
  type        = list(string)
  default     = []
}

## EC2 Details ==============================================

variable "ami_master" {
  description = "AMI ID of the EC2 Instance"
  type        = string
  #default     = ""
}

variable "instance_type" {
  description = "Instance Type of the EC2 Instance"
  type        = string
  #default     = ""
}

variable "key_name" {
  description = "key_name of the EC2 Instance"
  type        = string
  #default     = ""
}
