variable "ec2_instance_type" {
  type        = string
  description = "instance type for ec2"
}

variable "ec2_ami_type" {
  type        = string
  description = "ami type for ec2"
}

variable "ec2_count" {
  type    = number
  default = 1
}

variable "subnets" {
  type = list(any)
}

variable "vpc_id" {
  type = string
}

# tags

variable "instance_name" {
  type = string
}

variable "owner_tag" {
  type = string
}

variable "bootcamp_tag" {
  type = string
}

variable "expiration_tag" {
  type = string
}

# keypair

variable "key_name" {
  type = string
}