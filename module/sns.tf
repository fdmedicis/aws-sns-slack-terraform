resource "aws_sns_topic" "topic" {
  name = var.sns_topic_name
  tags = merge(var.tags, var.sns_topic_tags)
}


resource "aws_sns_topic_subscription" "sns_notify_slack" {
  topic_arn = aws_sns_topic.topic.arn
  protocol  = "lambda"
  endpoint  = aws_lambda_function.sns_slack.arn
}

resource "aws_lambda_permission" "for_sns" {
  statement_id  = "AllowExecutionFromSNS"
  action        = "lambda:InvokeFunction"
  function_name = aws_lambda_function.sns_slack.function_name
  principal     = "sns.amazonaws.com"
  source_arn    = aws_sns_topic.topic.arn
}