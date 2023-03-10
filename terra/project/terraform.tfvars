project_region            = "eu-west-2"
project_vpc_cidr          = "10.16.0.0/16"
project_pubsub_cidrs      = ["10.16.0.0/24", "10.16.1.0/24"]
project_ec2_instance_type = "t3a.small"
project_ec2_ami_type      = "ami-0d09654d0a20d3ae2"

project_key_name = "generated_key"

project_instance_name  = "yotambenz-tf-lb"
project_owner_tag      = "yotamb"
project_bootcamp_tag   = "17"
project_expiration_tag = "26-02-2023"

project_tg_path                = "/"
project_tg_port                = 80
project_tg_interval            = 30
project_tg_protocol            = "HTTP"
project_tg_timeout             = 7
project_tg_healthy_threshold   = 5
project_tg_unhealthy_threshold = 3
