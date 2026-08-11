resource "aws_sns_topic" "event_notifications" {
  name = "${var.project_name}-notifications"

  tags = {
    Name        = "${var.project_name}-notifications"
    Project     = var.project_name
    Environment = "dev"
  }
}
