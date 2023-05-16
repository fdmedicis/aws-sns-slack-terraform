AWS-SNS-SLACK-TERRAFORM
=======================
This a sns topic and propagate those to a slack channel using lambda.
The Lambda uses python code contained in `module/src/main.py`.

This module creates:
1) SNS topic which will be used by the systems which need to report to slack.
2) SNS subscription for Lambda and the new topic.
3) Lambda permission for the SNS topic.
4) Lambda function which will push the messages from sns to slack.
5) IAM role for the Lambda to be able to run.


Module Input Variables
----------------------

- `lambda_function_name` - The name of the Lambda function to create.
- `sns_topic_name` - The name of the SNS topic to create.
- `slack_webhook_url` - The URL of Slack webhook. I would recommend it to keep it a secret or at least in the AWS parameter store.
- `slack_channel` - The name of the channel in Slack for notifications.
- `slack_username` - The username that will appear on Slack messages.
- `slack_emoji` - A custom emoji that will appear on Slack messages.
- `tags` - A map of tags to add to all resources.
- `iam_role_tags` - Additional tags for the IAM role.
- `lambda_function_tags` - Additional tags for the Lambda function.
- `sns_topic_tags` - Additional tags for the SNS topic.


Module Output Variables
----------------------

- `sns_topic_arn` - SNS topic ARN.

Usage
-----
You probably want to copy the repo in your project, so you don't have to access it remotely.

Option 1

```hcl
module "sns_to_slack" {
  source            = "github.com/fdmedicis/aws-sns-slack-terraform/module"

  sns_topic_name    = "aws-to-slack"
  slack_webhook_url = YOUR_URL_WEBHOOK
  slack_emoji       = ":robot_face:"
  slack_channel     = "#sns-alerts"
}
```

Option 2 (with a bit more of detail)

```hcl
data "aws_ssm_parameter" "hook" {
  name = "/slack-hook/alerts"
}

module "sns_to_slack" {
  source                = "github.com/fdmedicis/aws-sns-slack-terraform/module/"

  lambda_function_name  = "sns-to-slack"
  sns_topic_name        = "aws-to-slack"
  slack_webhook_url     = data.aws_ssm_parameter.hook.value
  slack_channel         = "#sns-alerts"
  slack_username        = ""
  slack_emoji           = ":robot_face:"
  tags                  = local.tags
  iam_role_tags         = local.iam_tags
  lambda_function_tags  = local.lambda_tags
  sns_topic_tags        = local.sns_tags
}

locals {
  account = "YOUR_ACCOUNT"
  tags = {
    account = local.account
  }
  iam_tags = {
    account = local.account
    env     = "test"
   }
  lambda_tags = {
    tag1 = "boo"
    tag2 = "bee"
    
  }
  sns_tags = {
    tag3 = "bis"
    tag4 = "bas"
   }
}
```
