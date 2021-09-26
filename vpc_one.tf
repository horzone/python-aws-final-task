resource "aws_vpc" "vpc_one" {
  cidr_block = "10.10.8.0/22"
  tags = {
    Name = "my_vpc_one"
  }
}

resource "aws_internet_gateway" "igw_one" {
  vpc_id = aws_vpc.vpc_one.id
}

resource "aws_route" "route_one" {
  route_table_id         = aws_vpc.vpc_one.main_route_table_id
  destination_cidr_block = "0.0.0.0/0"
  gateway_id             = aws_internet_gateway.igw_one.id
}

resource "aws_subnet" "subnet_one_public" {
  vpc_id                  = aws_vpc.vpc_one.id
  cidr_block              = "10.10.8.0/24"
  map_public_ip_on_launch = true
  availability_zone       = "us-east-1a"
}
resource "aws_subnet" "subnet_one_private" {
  vpc_id                  = aws_vpc.vpc_one.id
  cidr_block              = "10.10.10.0/24"
  map_public_ip_on_launch = false
  availability_zone       = "us-east-1b"
}
resource "aws_subnet" "subnet_2_one_private" {
  vpc_id                  = aws_vpc.vpc_one.id
  cidr_block              = "10.10.11.0/24"
  map_public_ip_on_launch = false
  availability_zone       = "us-east-1c"
}
resource "aws_security_group" "allow_any-my_vpc_one" {
  name        = "allow_any"
  description = "allow any"
  vpc_id      = aws_vpc.vpc_one.id
  ingress {
    description = "any"
    from_port   = 0
    to_port     = 0
    protocol    = "-1"
    cidr_blocks = ["0.0.0.0/0"]
  }
  egress {
    description = "any"
    from_port   = 0
    to_port     = 0
    protocol    = "-1"
    cidr_blocks = ["0.0.0.0/0"]
  }
}

resource "aws_security_group" "rule_for_private_one" {
  name        = "ssh_bastion"
  description = "ssh_bastion"
  vpc_id      = aws_vpc.vpc_one.id
  ingress {
    description = "ssh_bastion"
    from_port   = 22
    to_port     = 22
    protocol    = "tcp"
    cidr_blocks = ["10.10.8.0/24"]
  }
  ingress {
    description = "nginx"
    from_port   = 8888
    to_port     = 8888
    protocol    = "tcp"
    cidr_blocks = ["0.0.0.0/0"]
  }
  ingress {
    description = "nginx"
    from_port   = 8888
    to_port     = 8888
    protocol    = "udp"
    cidr_blocks = ["0.0.0.0/0"]
  }
  egress {
    description = "any"
    from_port   = 0
    to_port     = 0
    protocol    = "-1"
    cidr_blocks = ["0.0.0.0/0"]
  }
}
