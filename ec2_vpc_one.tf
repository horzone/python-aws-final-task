resource "aws_instance" "public_ec2_vpc_one_bastion" {
  associate_public_ip_address = true
  ami                         = "ami-087c17d1fe0178315"
  subnet_id                   = aws_subnet.subnet_one_public.id
  instance_type               = "t2.micro"
  vpc_security_group_ids      = [aws_security_group.allow_any-my_vpc_one.id]
  key_name                    = aws_key_pair.key_pair.key_name
  provisioner "file" {
    source      = "./ebs.txt"
    destination = "/home/ec2-user/ebs.txt"

    connection {
      type        = "ssh"
      user        = "ec2-user"
      private_key = tls_private_key.key.private_key_pem
      host        = self.public_ip
    }
  }
  user_data = file("add_teacher.sh")
  tags = {
    Name        = "BASTION"
    owner       = "ME"
    project     = "test"
    environment = "BASTION_ENV"
  }
  volume_tags = {
    owner       = "ME"
    project     = "test"
    environment = "BASTION_ENV"
  }
}
