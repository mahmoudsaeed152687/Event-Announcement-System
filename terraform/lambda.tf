data "archive_file" "subscription_lambda" {
  type        = "zip"
  source_file = "../lambda/subscription/lambda_function.py"
  output_path = "${path.module}/subscription_lambda.zip"
}

data "archive_file" "event_lambda" {
  type        = "zip"
  source_file = "../lambda/event_registration/lambda_function.py"
  output_path = "${path.module}/event_lambda.zip"
}

resource "aws_lambda_function" "subscription" {
  function_name = "${var.project_name}-subscription"

  role = aws_iam_role.subscription_lambda_role.arn

  handler = "lambda_function.lambda_handler"
  runtime = "python3.12"

  filename         = data.archive_file.subscription_lambda.output_path
  source_code_hash = data.archive_file.subscription_lambda.output_base64sha256

  environment {
    variables = {
      SNS_TOPIC_ARN = aws_sns_topic.event_notifications.arn
    }
  }

  tags = {
    Name    = "${var.project_name}-subscription"
    Project = var.project_name
  }
}

resource "aws_lambda_function" "event_registration" {
  function_name = "${var.project_name}-event-registration"

  role = aws_iam_role.event_lambda_role.arn

  handler = "lambda_function.lambda_handler"
  runtime = "python3.12"

  filename         = data.archive_file.event_lambda.output_path
  source_code_hash = data.archive_file.event_lambda.output_base64sha256

  environment {
    variables = {
      BUCKET_NAME   = aws_s3_bucket.website.bucket
      SNS_TOPIC_ARN = aws_sns_topic.event_notifications.arn
    }
  }

  tags = {
    Name    = "${var.project_name}-event-registration"
    Project = var.project_name
  }
}

