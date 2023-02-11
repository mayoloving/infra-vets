output "public_ip" {
  value = tolist(aws_instance.yotambenz-tf-ec2[*].public_ip)
}
