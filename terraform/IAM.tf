# Subscription Lambda Role
resource "aws_iam_role" "subscription_lambda_role" {
  name = "${var.project_name}-subscription-role"

  assume_role_policy = jsonencode({
    Version = "2012-10-17"

    Statement = [
      {
        Effect = "Allow"

        Principal = {
          Service = "lambda.amazonaws.com"
        }

        Action = "sts:AssumeRole"
      }
    ]
  })
}

resource "aws_iam_role_policy" "subscription_lambda_policy" {
  name = "${var.project_name}-subscription-policy"
  role = aws_iam_role.subscription_lambda_role.id

  policy = jsonencode({
    Version = "2012-10-17"

    Statement = [
      {
        Effect = "Allow"

        Action = [
          "sns:Subscribe"
        ]

        Resource = aws_sns_topic.event_notifications.arn
      },

      {
        Effect = "Allow"

        Action = [
          "logs:CreateLogGroup",
          "logs:CreateLogStream",
          "logs:PutLogEvents"
        ]

        Resource = "*"
      }
    ]
  })
}

# Event Registration Role

resource "aws_iam_role" "event_lambda_role" {
  name = "${var.project_name}-event-role"

  assume_role_policy = jsonencode({
    Version = "2012-10-17"

    Statement = [
      {
        Effect = "Allow"

        Principal = {
          Service = "lambda.amazonaws.com"
        }

        Action = "sts:AssumeRole"
      }
    ]
  })
}

resource "aws_iam_role_policy" "event_lambda_policy" {
  name = "${var.project_name}-event-policy"
  role = aws_iam_role.event_lambda_role.id

  policy = jsonencode({
    Version = "2012-10-17"

    Statement = [
      {
        Effect = "Allow"

        Action = [
          "s3:GetObject",
          "s3:PutObject"
        ]

        Resource = "${aws_s3_bucket.website.arn}/events.json"
      },

      {
        Effect = "Allow"

        Action = [
          "sns:Publish"
        ]

        Resource = aws_sns_topic.event_notifications.arn
      },

      {
        Effect = "Allow"

        Action = [
          "logs:CreateLogGroup",
          "logs:CreateLogStream",
          "logs:PutLogEvents"
        ]

        Resource = "*"
      }
    ]
  })
}
