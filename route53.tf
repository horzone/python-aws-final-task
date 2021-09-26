resource "aws_route53_zone" "myinternaldns" {
  name = "myinternaldns.com"
  vpc {
    vpc_id = aws_vpc.vpc_one.id
  }

}

resource "aws_route53_zone_association" "vpc_two" {
  zone_id = aws_route53_zone.myinternaldns.zone_id
  vpc_id  = aws_vpc.vpc_two.id
}
