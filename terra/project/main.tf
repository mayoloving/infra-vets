module "compute_structure" {
  source = "../compute_module"

  ec2_instance_type = var.project_ec2_instance_type
  ec2_ami_type      = var.project_ec2_ami_type

  tg_path                = var.project_tg_path
  tg_port                = var.project_tg_port
  tg_interval            = var.project_tg_interval
  tg_protocol            = var.project_tg_protocol
  tg_timeout             = var.project_tg_timeout
  tg_healthy_threshold   = var.project_tg_healthy_threshold
  tg_unhealthy_threshold = var.project_tg_unhealthy_threshold

  instance_name  = var.project_instance_name
  owner_tag      = var.project_owner_tag
  bootcamp_tag   = var.project_bootcamp_tag
  expiration_tag = var.project_expiration_tag

  key_name = var.project_key_name

  vpc_id  = module.network_structure.vpc_id
  subnets = module.network_structure.subnets_ids
}

module "network_structure" {
  source = "../network_module"

  vpc_cidr       = var.project_vpc_cidr
  pubsub_cidrs   = var.project_pubsub_cidrs
  owner_tag      = var.project_owner_tag
  bootcamp_tag   = var.project_bootcamp_tag
  expiration_tag = var.project_expiration_tag
}
