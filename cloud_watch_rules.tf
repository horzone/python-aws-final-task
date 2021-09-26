resource "aws_cloudwatch_event_rule" "rule_for_lambda_dns" {
  name          = "rule_for_lambda_dns"
  event_pattern = <<EOF
  {
    "source": [
      "aws.autoscaling"
    ],
    "detail-type": [
      "EC2 Instance Launch Successful",
      "EC2 Instance Terminate Successful",
      "EC2 Instance Launch Unsuccessful",
      "EC2 Instance Terminate Unsuccessful"
    ]
  }
EOF
}

resource "aws_cloudwatch_event_target" "lambda_dns" {
  rule = aws_cloudwatch_event_rule.rule_for_lambda_dns.name
  arn  = aws_lambda_function.lambda_dns.arn
}

resource "aws_cloudwatch_event_rule" "rule_for_lambda_ebs_tags" {
  name                = "rule_for_lambda_ebs_tags"
  schedule_expression = "rate(1 day)"
}

resource "aws_cloudwatch_event_target" "lambda_ebs" {
  rule = aws_cloudwatch_event_rule.rule_for_lambda_ebs_tags.name
  arn  = aws_lambda_function.lambda_ebs_tags.arn
}
