resource "aws_iam_role" "iam_for_lambda_dns" {
  name               = "iam_for_lambda_dns"
  assume_role_policy = <<EOF
{
  "Version": "2012-10-17",
  "Statement": [
    {
      "Action": "sts:AssumeRole",
      "Principal": {
        "Service": "lambda.amazonaws.com"
      },
      "Effect": "Allow",
      "Sid": ""
    }
  ]
}
EOF
}

resource "aws_iam_policy" "lambda_dns_policy" {
  name        = "allow_lambda_dns"
  path        = "/"
  description = "allow lamda to add/delete records in route53"
  policy = jsonencode({
    "Version" : "2012-10-17",
    "Statement" : [
      {
        "Sid" : "VisualEditor0",
        "Effect" : "Allow",
        "Action" : [
          "ec2:DescribeInstances",
          "route53:GetHostedZone",
          "route53:ListHostedZones",
          "route53:ChangeResourceRecordSets",
          "logs:CreateLogGroup",
          "logs:PutLogEvents",
          "logs:CreateLogStream",
          "autoscaling:DescribeAutoScalingGroups",
          "route53:ListTrafficPolicies",
          "route53:ListResourceRecordSets"
        ],
        "Resource" : "*"
      }
    ]
  })
}

resource "aws_iam_role_policy_attachment" "lambda_dns_policy_attach" {
  role       = aws_iam_role.iam_for_lambda_dns.name
  policy_arn = aws_iam_policy.lambda_dns_policy.arn
}
resource "aws_iam_role_policy_attachment" "lambda_dns_policy_standart_attach" {
  role       = aws_iam_role.iam_for_lambda_dns.name
  policy_arn = "arn:aws:iam::aws:policy/service-role/AWSLambdaBasicExecutionRole"
}

resource "aws_iam_role" "iam_for_lambda_ebs_tags" {
  name               = "iam_for_lambda_ebs_tags"
  assume_role_policy = <<EOF
{
  "Version": "2012-10-17",
  "Statement": [
    {
      "Action": "sts:AssumeRole",
      "Principal": {
        "Service": "lambda.amazonaws.com"
      },
      "Effect": "Allow",
      "Sid": ""
    }
  ]
}
EOF
}
resource "aws_iam_policy" "lambda_ebs_tags_policy" {
  name        = "allow_lambda_ebs_tags"
  path        = "/"
  description = "allow lamda modify tags at ebs"
  policy = jsonencode({
    "Version" : "2012-10-17",
    "Statement" : [
      {
        "Sid" : "VisualEditor0",
        "Effect" : "Allow",
        "Action" : "ec2:CreateTags",
        "Resource" : "arn:aws:ec2:*:469204214656:volume/*"
      },
      {
        "Sid" : "VisualEditor1",
        "Effect" : "Allow",
        "Action" : [
          "ec2:DescribeInstances",
          "ec2:DescribeVolumeStatus",
          "ec2:DescribeVolumes",
          "ec2:DescribeVolumesModifications",
          "ec2:DescribeInstanceStatus"
        ],
        "Resource" : "*"
      }
    ]
  })
}

resource "aws_iam_role_policy_attachment" "lambda_ebs_tags_policy_attach" {
  role       = aws_iam_role.iam_for_lambda_ebs_tags.name
  policy_arn = aws_iam_policy.lambda_ebs_tags_policy.arn
}
resource "aws_iam_role_policy_attachment" "lambda_ebs_tags_policy_standart_attach" {
  role       = aws_iam_role.iam_for_lambda_ebs_tags.name
  policy_arn = "arn:aws:iam::aws:policy/service-role/AWSLambdaBasicExecutionRole"
}


resource "aws_iam_role" "ec2_s3" {
  name = "ec2_s3"
  assume_role_policy = jsonencode({
    "Version" : "2012-10-17",
    "Statement" : [
      {
        "Sid" : "",
        "Effect" : "Allow",
        "Principal" : {
          "Service" : [
            "ec2.amazonaws.com"
          ]
        },
        "Action" : "sts:AssumeRole"
      }
    ]
  })

  tags = {
    tag-key = "ec2_s3"
  }
}

resource "aws_iam_role_policy_attachment" "ec2_s3" {
  role       = aws_iam_role.ec2_s3.name
  policy_arn = "arn:aws:iam::aws:policy/AmazonS3FullAccess"
}

resource "aws_iam_instance_profile" "ec2_s3" {
  name = "ec2_s3"
  role = aws_iam_role.ec2_s3.name
}

resource "aws_iam_policy" "deny_whithout_tags" {
  name        = "deny_whithout_tags"
  path        = "/"
  description = "Deny runec2 and ebs volumes whithout tags 'owner, project, environment'"
  policy = jsonencode({
    "Version" : "2012-10-17",
    "Statement" : [
      {
        "Sid" : "VisualEditor0",
        "Effect" : "Deny",
        "Action" : "ec2:RunInstances",
        "Resource" : [
          "arn:aws:ec2:*:469204214656:instance/*",
          "arn:aws:ec2:*:469204214656:volume/*"
        ],
        "Condition" : {
          "ForAllValues:StringNotEquals" : {
            "aws:TagKeys" : [
              "owner",
              "project",
              "environment"
            ]
          }
        }
      }
    ]
  })
}
resource "aws_iam_user_policy_attachment" "attache_to_user" {
  user       = "iamadmin"
  policy_arn = aws_iam_policy.deny_whithout_tags.arn
}
