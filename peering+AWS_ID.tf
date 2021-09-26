variable "region" {
  description = "region"
  default     = "us-east-1"
  type        = string
}

provider "aws" {
  access_key = ""
  secret_key = ""
  region     = var.region
}

data "aws_caller_identity" "current" {}


resource "aws_vpc_peering_connection" "one_vpc_2_two_vpc" {
  vpc_id        = aws_vpc.vpc_one.id
  peer_owner_id = data.aws_caller_identity.current.account_id
  peer_vpc_id   = aws_vpc.vpc_two.id
  auto_accept   = true
}

resource "aws_route" "one_vpc_2_two_vpc" {
  route_table_id            = aws_vpc.vpc_one.main_route_table_id
  destination_cidr_block    = aws_vpc.vpc_two.cidr_block
  vpc_peering_connection_id = aws_vpc_peering_connection.one_vpc_2_two_vpc.id
}

resource "aws_route" "two_vpc_2_one_vpc" {
  route_table_id            = aws_vpc.vpc_two.main_route_table_id
  destination_cidr_block    = aws_vpc.vpc_one.cidr_block
  vpc_peering_connection_id = aws_vpc_peering_connection.one_vpc_2_two_vpc.id
}
