resource "aws_apigatewayv2_api" "main" {
  name          = "${var.project_name}-api"
  protocol_type = "HTTP"

  cors_configuration {
    allow_origins = ["*"]

    allow_methods = [
      "POST",
      "OPTIONS"
    ]

    allow_headers = [
      "content-type"
    ]
  }

  tags = {
    Name    = "${var.project_name}-api"
    Project = var.project_name
  }
}

#Lambda Integration
resource "aws_apigatewayv2_integration" "subscription" {
  api_id = aws_apigatewayv2_api.main.id

  integration_type = "AWS_PROXY"

  integration_uri = aws_lambda_function.subscription.invoke_arn

  payload_format_version = "2.0"
}

#Event lambda
resource "aws_apigatewayv2_integration" "event_registration" {
  api_id = aws_apigatewayv2_api.main.id

  integration_type = "AWS_PROXY"

  integration_uri = aws_lambda_function.event_registration.invoke_arn

  payload_format_version = "2.0"
}

#Route for subscribe
resource "aws_apigatewayv2_route" "subscribe" {
  api_id = aws_apigatewayv2_api.main.id

  route_key = "POST /subscribers"

  target = "integrations/${aws_apigatewayv2_integration.subscription.id}"
}

#Route for event 
resource "aws_apigatewayv2_route" "new_event" {
  api_id = aws_apigatewayv2_api.main.id

  route_key = "POST /new-events"

  target = "integrations/${aws_apigatewayv2_integration.event_registration.id}"
}

#Lambda permissions
#-Subscription
resource "aws_lambda_permission" "api_gateway_subscription" {
  statement_id = "AllowAPIGatewayInvokeSubscription"

  action = "lambda:InvokeFunction"

  function_name = aws_lambda_function.subscription.function_name

  principal = "apigateway.amazonaws.com"

  source_arn = "${aws_apigatewayv2_api.main.execution_arn}/*/*"
}

#-Event Registration
resource "aws_lambda_permission" "api_gateway_event" {
  statement_id = "AllowAPIGatewayInvokeEvent"

  action = "lambda:InvokeFunction"

  function_name = aws_lambda_function.event_registration.function_name

  principal = "apigateway.amazonaws.com"

  source_arn = "${aws_apigatewayv2_api.main.execution_arn}/*/*"
}

#Api stage
resource "aws_apigatewayv2_stage" "prod" {
  api_id = aws_apigatewayv2_api.main.id

  name = "prod"

  auto_deploy = true
}

