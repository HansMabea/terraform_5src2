variable "aws_region" {

  description = "Region of aws deployment"
  type        = string

}

variable "aws_access_key" {

  description = "AWS Access key for account"
  type        = string

}

variable "aws_secret_key" {

  description = "AWS Secret key for account"
  type        = string

}

variable "aws_token_session" {

  description = "AWS Session Token"
  type        = string

}

variable "ssh_key_name" {

  description = "Name of SSH Key"
  type        = string

}

variable "public_ssh_key" {

  description = "Public ssh key to add on aws account"
  type        = string

}

#Réseau
variable "vpc_cidr_block" {}
variable "subnet_cidr_block" {}

# Groupe de sécurité
variable "sg_name" {}
variable "sg_ingress_protocol" {}
variable "sg_ingress_from_port" {}
variable "sg_ingress_to_port" {}
variable "sg_ingress_cidr_blocks" {}
variable "sg_egress_protocol" {}
variable "sg_egress_from_port" {}
variable "sg_egress_to_port" {}
variable "sg_egress_cidr_blocks" {}

#Variable EC2
variable "ec2_ami" {}
variable "ec2_instance_type" {}
variable "ec2_name" {}