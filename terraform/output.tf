output "s3_bucket_name" {
  value = aws_s3_bucket.website.bucket
}

output "website_endpoint" {
  value = aws_s3_bucket_website_configuration.website.website_endpoint
}

output "sns_topic_arn" {
  value = aws_sns_topic.event_notifications.arn
}

#API_url
output "api_url" {
  value = aws_apigatewayv2_stage.prod.invoke_url
}
