# tags
variable "project_owner_tag" {
  type = string
}

variable "project_bootcamp_tag" {
  type = string
}

variable "project_expiration_tag" {
  type = string
}

variable "project_vpc_cidr" {
  type        = string
  description = "CIDR for vpc network"
}

variable "project_ec2_instance_type" {
  type        = string
  description = "instance type for ec2"
}

variable "project_ec2_ami_type" {
  type        = string
  description = "ami type for ec2"
}

variable "project_pubsub_cidrs" {
  type = list(any)
}

variable "project_instance_name" {
  type = string
}

variable "project_key_name" {
  type = string
}

variable "project_region" {
  type = string
}