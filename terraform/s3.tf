#Creating S3-bucket
resource "aws_s3_bucket" "website" {
  bucket = "${var.project_name}-website-${random_id.bucket_suffix.hex}"

  tags = {
    Name        = "${var.project_name}-website"
    Project     = var.project_name
    Environment = "dev"
  }
}

#S3 hosts a website 
resource "aws_s3_bucket_website_configuration" "website" {
  bucket = aws_s3_bucket.website.id

  index_document {
    suffix = "index.html"
  }

  error_document {
    key = "index.html"
  }
}

#Making public access for S3-bucket 
resource "aws_s3_bucket_public_access_block" "website" {
  bucket = aws_s3_bucket.website.id

  block_public_acls       = false
  block_public_policy     = false
  ignore_public_acls      = false
  restrict_public_buckets = false
}

#S3-bucket policy
resource "aws_s3_bucket_policy" "website" {
  bucket = aws_s3_bucket.website.id

  depends_on = [
    aws_s3_bucket_public_access_block.website
  ]

  policy = jsonencode({
    Version = "2012-10-17"

    Statement = [
      {
        Sid       = "PublicReadGetObject"
        Effect    = "Allow"
        Principal = "*"

        Action = [
          "s3:GetObject"
        ]

        Resource = "${aws_s3_bucket.website.arn}/*"
      }
    ]
  })
}

resource "aws_s3_object" "index" {
  bucket       = aws_s3_bucket.website.id
  key          = "index.html"
  source       = "../website/index.html"
  content_type = "text/html"
}

resource "aws_s3_object" "css" {
  bucket       = aws_s3_bucket.website.id
  key          = "style.css"
  source       = "../website/style.css"
  content_type = "text/css"
}

resource "aws_s3_object" "js" {
  bucket       = aws_s3_bucket.website.id
  key          = "script.js"
  source       = "../website/script.js"
  content_type = "application/javascript"
}

resource "aws_s3_object" "events" {
  bucket       = aws_s3_bucket.website.id
  key          = "events.json"
  source       = "../website/events.json"
  content_type = "application/json"
}

