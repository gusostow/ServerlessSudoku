resource "aws_iam_role" "lambda_exec_role" {
  name = "lambda_exec_role"

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

resource "aws_iam_policy" "develop_lambda" {
  name        = "develop_lambda"
  description = "Policy for users to develop and test lambdas"

  policy = <<EOF
{
"Version": "2012-10-17",
"Statement": [
    {
        "Sid": "DevelopFunctions",
        "Effect": "Allow", 
        "Action": ["lambda:CreateFunction"],
        "Resource": "*"
    },
    {
        "Sid": "GatewayAll",
        "Effect": "Allow", 
        "Action": ["apigateway:*"],
        "Resource": "*"
    }
]
}
EOF
}

resource "aws_iam_policy_attachment" "attach_develop_lambda" {
  name       = "attach-develop-lambda"
  users      = ["${var.iam_profile}"]
  policy_arn = "${aws_iam_policy.develop_lambda.arn}"
}