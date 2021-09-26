resource "aws_vpc" "vpc_two" {
  cidr_block = "10.10.100.0/22"
  tags = {
    Name = "my_vpc_two"
  }
}
resource "aws_internet_gateway" "igw_two" {
  vpc_id = aws_vpc.vpc_two.id
}

resource "aws_route" "route_two" {
  route_table_id         = aws_vpc.vpc_two.main_route_table_id
  destination_cidr_block = "0.0.0.0/0"
  gateway_id             = aws_internet_gateway.igw_two.id
}

resource "aws_subnet" "subnet_two_public" {
  vpc_id                  = aws_vpc.vpc_two.id
  cidr_block              = "10.10.100.0/24"
  map_public_ip_on_launch = true
  availability_zone       = "us-east-1a"
}
resource "aws_subnet" "subnet_two_private" {
  vpc_id                  = aws_vpc.vpc_two.id
  cidr_block              = "10.10.101.0/24"
  map_public_ip_on_launch = false
  availability_zone       = "us-east-1b"
}

resource "aws_subnet" "subnet_2_two_private" {
  vpc_id                  = aws_vpc.vpc_two.id
  cidr_block              = "10.10.102.0/24"
  map_public_ip_on_launch = false
  availability_zone       = "us-east-1c"
}
resource "aws_security_group" "allow_any-my_vpc_two" {
  name        = "allow_any"
  description = "allow any"
  vpc_id      = aws_vpc.vpc_two.id
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

resource "aws_security_group" "rule_for_private_two" {
  name        = "ssh_bastion"
  description = "ssh_bastion"
  vpc_id      = aws_vpc.vpc_two.id
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
resource "aws_vpc_endpoint" "s3_for_distrib" {
  vpc_id       = aws_vpc.vpc_two.id
  service_name = "com.amazonaws.us-east-1.s3"
}
resource "aws_vpc_endpoint_route_table_association" "associate" {
  route_table_id  = aws_vpc.vpc_two.main_route_table_id
  vpc_endpoint_id = aws_vpc_endpoint.s3_for_distrib.id
}
