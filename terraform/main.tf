locals {
  project_name = var.project_name
}

resource "random_id" "bucket_suffix" {
  byte_length = 4
}
