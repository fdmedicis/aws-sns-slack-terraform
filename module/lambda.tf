resource "aws_lambda_function" "sns_slack" {
  function_name    = var.lambda_function_name
  filename         = "slack.zip"
  source_code_hash = data.archive_file.python_lambda_package.output_base64sha256
  role             = aws_iam_role.iam_lambda.arn

  runtime = "python3.7"
  handler = "main.lambda_handler"

  environment {
    variables = {
      HOOK_URL = var.slack_webhook_url
      CHANNEL  = var.slack_channel
      USERNAME = var.slack_username
      EMOJI    = var.slack_emoji
    }
  }

}

data "archive_file" "python_lambda_package" {
  type        = "zip"
  source_file = "${path.module}/src/main.py"
  output_path = "slack.zip"
}

resource "aws_iam_role" "iam_lambda" {
  name = "${var.lambda_function_name}-lambda-role"

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
  tags               = var.iam_role_tags
}