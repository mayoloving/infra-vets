# SG for EC2
resource "aws_security_group" "yotam-sg-terraformeasy" {
  name   = "yotam-sg-terraformeasy"
  vpc_id = var.vpc_id

  #Incoming traffic
  ingress {
    from_port   = 22
    to_port     = 22
    protocol    = "tcp"
    cidr_blocks = ["0.0.0.0/0"]
  }

  ingress {
    from_port       = 0
    to_port         = 0
    protocol        = "-1"
    security_groups = [aws_security_group.yotam-sg-albeasy.id] # to check again
  }

  #Outgoing traffic
  egress {
    from_port   = 0
    protocol    = "-1"
    to_port     = 0
    cidr_blocks = ["0.0.0.0/0"]
  }
}

# ==============================================================================

# Create 2 EC2 (depends on count)
resource "aws_instance" "yotambenz-tf-ec2" {
  ami                         = var.ec2_ami_type
  instance_type               = var.ec2_instance_type
  count                       = var.ec2_count
  subnet_id                   = var.subnets[count.index]
  vpc_security_group_ids      = [aws_security_group.yotam-sg-terraformeasy.id]
  associate_public_ip_address = true
  key_name                    = local_file.pem_file.filename

  user_data = <<-EOF
  #!/bin/bash
  sudo apt-get update
  sudo apt-get install -y docker.io docker-compose
  sudo usermod -aG docker ubuntu
  sudo curl -L https://github.com/docker/compose/releases/download/1.26.2/docker-compose-$(uname -s)-$(uname -m) -o /usr/local/bin/docker-compose
  sudo chmod +x /usr/local/bin/docker-compose
  EOF

  provisioner "file" {
    source      = "../../init"
    destination = "/home/ubuntu"

    connection {
      host        = self.public_ip
      user        = "ubuntu"
      type        = "ssh"
      private_key = local_file.pem_file.content
    }
  }

  provisioner "remote-exec" {

    connection {
      host        = self.public_ip
      user        = "ubuntu"
      type        = "ssh"
      private_key = local_file.pem_file.content
    }

    inline = [
      "cd init && bash init.sh",
    ]
  }


  tags = {
    Name            = "${var.instance_name}-${count.index}"
    owner           = var.owner_tag
    expiration_date = var.expiration_tag
    bootcamp        = var.bootcamp_tag
  }
}

# key pair

# https://stackoverflow.com/questions/49743220/how-do-i-create-an-ssh-key-in-terraform
# Terraform can generate SSL/SSH private keys using the tls_private_key resource

resource "tls_private_key" "sshkey" {
  algorithm = "RSA"
  rsa_bits  = 4096
}

resource "aws_key_pair" "generated_key" {
  key_name   = var.key_name
  public_key = tls_private_key.sshkey.public_key_openssh
}

resource "local_file" "pem_file" {
  filename = "generated_key"
  content  = tls_private_key.sshkey.private_key_pem
}

#=======================================================================================
resource "local_file" "ec2_ip" {
  count    = var.ec2_count
  filename = "../../ec2_ip.txt"
  content  = aws_instance.yotambenz-tf-ec2[count.index].public_ip
}

#=======================================ALB=============================================


# SG for alb
resource "aws_security_group" "yotam-sg-albeasy" {
  name   = "yotam-sg-albeasy"
  vpc_id = var.vpc_id

  #Incoming traffic
  ingress {
    from_port   = 80
    to_port     = 80
    protocol    = "tcp"
    cidr_blocks = ["0.0.0.0/0"]
  }

  #Outgoing traffic
  egress {
    from_port   = 0
    protocol    = "-1"
    to_port     = 0
    cidr_blocks = ["0.0.0.0/0"]
  }
}

# ==============================================================================

# create target-group
resource "aws_lb_target_group" "doiteasy-yotambenz-tg" {
  name        = "doiteasy-yotambenz-tg"
  port        = 80
  protocol    = "HTTP"
  vpc_id      = var.vpc_id
  target_type = "instance"

  health_check {
    path                = var.tg_path
    port                = var.tg_port
    interval            = var.tg_interval
    protocol            = var.tg_protocol
    timeout             = var.tg_timeout
    healthy_threshold   = var.tg_healthy_threshold
    unhealthy_threshold = var.tg_unhealthy_threshold
  }

  tags = {
    Name            = "doiteasy-yotambenz-tg"
    owner           = var.owner_tag
    expiration_date = var.expiration_tag
    bootcamp        = var.bootcamp_tag
  }
}

# create ALB 
resource "aws_lb" "yotambenz-alb" {
  name               = "alb-doiteasy"
  internal           = false
  security_groups    = [aws_security_group.yotam-sg-albeasy.id]
  subnets            = var.subnets
  ip_address_type    = "ipv4"
  load_balancer_type = "application"

  tags = {
    Name            = "alb-doiteasy"
    owner           = var.owner_tag
    expiration_date = var.expiration_tag
    bootcamp        = var.bootcamp_tag
  }
}

# alb listener
resource "aws_alb_listener" "yotam-alb-listener" {
  load_balancer_arn = aws_lb.yotambenz-alb.arn
  port              = 80
  protocol          = "HTTP"
  default_action {
    target_group_arn = aws_lb_target_group.doiteasy-yotambenz-tg.arn
    type             = "forward"
  }

}

# attachment to alb
resource "aws_lb_target_group_attachment" "attach-yotambenz-tg" {
  target_group_arn = aws_lb_target_group.doiteasy-yotambenz-tg.arn
  count            = var.ec2_count
  target_id        = aws_instance.yotambenz-tf-ec2[count.index].id
  port             = 80
}
