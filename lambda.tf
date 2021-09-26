resource "aws_lambda_function" "lambda_dns" {
  filename         = "./lambda_dns.zip"
  function_name    = "lambda_dns"
  role             = aws_iam_role.iam_for_lambda_dns.arn
  source_code_hash = filebase64sha256("lambda_dns.zip")
  runtime          = "python3.9"
  handler          = "lambda_function.lambda_handler"
}

resource "aws_lambda_function" "lambda_ebs_tags" {
  filename         = "./lambda_ebs_tags.zip"
  function_name    = "lambda_ebs_tags"
  role             = aws_iam_role.iam_for_lambda_ebs_tags.arn
  source_code_hash = filebase64sha256("lambda_ebs_tags.zip")
  runtime          = "python3.9"
  handler          = "lambda_function.lambda_handler"
}
