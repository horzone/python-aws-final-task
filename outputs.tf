output "ssh_connection_ec2_one" {
  value = "ssh -i ${local_file.private_key.filename} ec2-user@${aws_instance.public_ec2_vpc_one_bastion.public_ip}"
}
