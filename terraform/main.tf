terraform {
  required_version = ">= 1.5.0"
  required_providers {
    aws = {
      source  = "hashicorp/aws"
      version = "~> 5.0"
    }
  }

  # Recommended for production: store state remotely with locking instead
  # of the local backend, e.g.
  # backend "s3" {
  #   bucket         = "my-terraform-state-bucket"
  #   key            = "diagram-agent/terraform.tfstate"
  #   region         = "us-east-1"
  #   dynamodb_table = "terraform-locks"
  #   encrypt        = true
  # }
}

provider "aws" {
  region = var.aws_region
}

# >>> archly:group:vpc1 >>>
# VPC (network boundary)

resource "aws_vpc" "vpc1" {
  cidr_block           = var.vpc1_cidr_block
  enable_dns_support   = true
  enable_dns_hostnames = true
  tags = { Name = "VPC" }
}
# <<< archly:group:vpc1 <<<

# >>> archly:group:public1 >>>
# Public Subnet (subnet within 'VPC')

resource "aws_subnet" "public1" {
  vpc_id            = aws_vpc.vpc1.id
  cidr_block        = var.public1_cidr_block
  availability_zone = var.public1_availability_zone
  tags = { Name = "Public Subnet" }
}
# <<< archly:group:public1 <<<

# >>> archly:group:private1 >>>
# Private Subnet (subnet within 'VPC')

resource "aws_subnet" "private1" {
  vpc_id            = aws_vpc.vpc1.id
  cidr_block        = var.private1_cidr_block
  availability_zone = var.private1_availability_zone
  tags = { Name = "Private Subnet" }
}
# <<< archly:group:private1 <<<

# >>> archly:group:data1 >>>
# Data Subnet (subnet within 'VPC')

resource "aws_subnet" "data1" {
  vpc_id            = aws_vpc.vpc1.id
  cidr_block        = var.data1_cidr_block
  availability_zone = var.data1_availability_zone
  tags = { Name = "Data Subnet" }
}
# <<< archly:group:data1 <<<

# >>> archly:node:dns1 >>>
# Route 53 (dns)
resource "aws_route53_zone" "dns1" {
  name = var.dns1_domain_name
}
# <<< archly:node:dns1 <<<

# >>> archly:node:cdn1 >>>
# CloudFront (cdn)
resource "aws_cloudfront_distribution" "cdn1" {
  enabled = true
  # TODO: point this at the origin node in your diagram (S3 bucket / ALB)
  origin {
    domain_name = var.cdn1_origin_domain_name
    origin_id   = "cdn1-origin"
  }
  default_cache_behavior {
    allowed_methods       = ["GET", "HEAD"]
    cached_methods         = ["GET", "HEAD"]
    target_origin_id       = "cdn1-origin"
    viewer_protocol_policy = "redirect-to-https"
    forwarded_values {
      query_string = false
      cookies { forward = "none" }
    }
  }
  restrictions {
    geo_restriction { restriction_type = "none" }
  }
  viewer_certificate { cloudfront_default_certificate = true }
}
# <<< archly:node:cdn1 <<<

# >>> archly:node:waf1 >>>
# WAF (firewall)
resource "aws_wafv2_web_acl" "waf1" {
  name        = "waf1"
  description = "WAF"
  scope       = "REGIONAL"
  default_action { allow {} }
  visibility_config {
    cloudwatch_metrics_enabled = true
    metric_name                = "waf1"
    sampled_requests_enabled   = true
  }
}
# <<< archly:node:waf1 <<<

# >>> archly:node:alb1 >>>
# App Load Balancer (load_balancer) -- belongs to subnet 'Public Subnet' (see resource id 'public1' above; wire this resource's subnet/network args to it manually)
resource "aws_lb" "alb1" {
  name               = "alb1"
  internal           = false
  load_balancer_type = "application"
  subnets            = var.alb1_subnet_ids
  tags = { Name = "App Load Balancer" }
}
# <<< archly:node:alb1 <<<

# >>> archly:node:ec2_auto1 >>>
# Lambda (compute.serverless) -- belongs to subnet 'Private Subnet' (see resource id 'private1' above; wire this resource's subnet/network args to it manually)
resource "aws_lambda_function" "ec2_auto1" {
  function_name = "ec2_auto1"
  role          = var.ec2_auto1_execution_role_arn
  handler       = var.ec2_auto1_handler
  runtime       = var.ec2_auto1_runtime
  s3_bucket     = var.ec2_auto1_package_s3_bucket
  s3_key        = var.ec2_auto1_package_s3_key
}
# <<< archly:node:ec2_auto1 <<<

# >>> archly:node:rds1 >>>
# RDS Multi-AZ (database.relational) -- belongs to subnet 'Data Subnet' (see resource id 'data1' above; wire this resource's subnet/network args to it manually)
resource "aws_db_instance" "rds1" {
  identifier             = "rds1"
  engine                 = var.rds1_engine
  instance_class         = var.rds1_instance_class
  allocated_storage      = 20
  username               = var.rds1_username
  password               = var.rds1_password
  storage_encrypted      = true
  publicly_accessible    = false
  skip_final_snapshot    = false
}
# <<< archly:node:rds1 <<<

# >>> archly:node:cache1 >>>
# ElastiCache (database.cache) -- belongs to subnet 'Data Subnet' (see resource id 'data1' above; wire this resource's subnet/network args to it manually)
resource "aws_elasticache_replication_group" "cache1" {
  replication_group_id       = "cache1"
  description                = "ElastiCache"
  node_type                  = var.cache1_node_type
  num_cache_clusters         = 1
  engine                     = "redis"
  transit_encryption_enabled = true
  auth_token                 = var.cache1_auth_token
}
# <<< archly:node:cache1 <<<

# >>> archly:node:queue1 >>>
# SQS (queue)
resource "aws_sqs_queue" "queue1" {
  name = "queue1"
}
# <<< archly:node:queue1 <<<

# >>> archly:node:lambda1 >>>
# Lambda (compute.serverless)
resource "aws_lambda_function" "lambda1" {
  function_name = "lambda1"
  role          = var.lambda1_execution_role_arn
  handler       = var.lambda1_handler
  runtime       = var.lambda1_runtime
  s3_bucket     = var.lambda1_package_s3_bucket
  s3_key        = var.lambda1_package_s3_key
}
# <<< archly:node:lambda1 <<<

# >>> archly:node:dynamodb1 >>>
# DynamoDB (database.nosql)
resource "aws_dynamodb_table" "dynamodb1" {
  name         = "dynamodb1"
  billing_mode = "PAY_PER_REQUEST"
  hash_key     = "id"
  attribute {
    name = "id"
    type = "S"
  }
}
# <<< archly:node:dynamodb1 <<<

# >>> archly:node:s3_images >>>
# S3 Product Images (storage.object)
resource "aws_s3_bucket" "s3_images" {
  bucket = var.s3_images_bucket_name
}
resource "aws_s3_bucket_public_access_block" "s3_images" {
  bucket                  = aws_s3_bucket.s3_images.id
  block_public_acls       = true
  block_public_policy     = true
  ignore_public_acls      = true
  restrict_public_buckets = true
}
resource "aws_s3_bucket_server_side_encryption_configuration" "s3_images" {
  bucket = aws_s3_bucket.s3_images.id
  rule {
    apply_server_side_encryption_by_default { sse_algorithm = "AES256" }
  }
}
# <<< archly:node:s3_images <<<

# >>> archly:node:monitor1 >>>
# CloudWatch (monitoring)
resource "aws_cloudwatch_log_group" "monitor1" {
  name              = "/monitor1"
  retention_in_days = 30
}
# <<< archly:node:monitor1 <<<