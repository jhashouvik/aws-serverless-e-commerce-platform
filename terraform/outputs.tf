# >>> archly:node:dns1 >>>
output "dns1_zone_id" {
  description = "Route53 hosted zone id"
  value       = aws_route53_zone.dns1.zone_id
  sensitive   = false
}
# <<< archly:node:dns1 <<<

# >>> archly:node:alb1 >>>
output "alb1_dns_name" {
  description = "Public DNS name of the load balancer"
  value       = aws_lb.alb1.dns_name
  sensitive   = false
}
# <<< archly:node:alb1 <<<

# >>> archly:node:ec2_auto1 >>>
output "ec2_auto1_id" {
  description = "Instance id"
  value       = aws_instance.ec2_auto1.id
  sensitive   = false
}
# <<< archly:node:ec2_auto1 <<<

# >>> archly:node:rds1 >>>
output "rds1_endpoint" {
  description = "Connection endpoint"
  value       = aws_db_instance.rds1.endpoint
  sensitive   = false
}
# <<< archly:node:rds1 <<<

# >>> archly:node:queue1 >>>
output "queue1_url" {
  description = "Queue URL"
  value       = aws_sqs_queue.queue1.url
  sensitive   = false
}
# <<< archly:node:queue1 <<<

# >>> archly:node:lambda1 >>>
output "lambda1_arn" {
  description = "Function ARN"
  value       = aws_lambda_function.lambda1.arn
  sensitive   = false
}
# <<< archly:node:lambda1 <<<

# >>> archly:node:dynamodb1 >>>
output "dynamodb1_arn" {
  description = "Table ARN"
  value       = aws_dynamodb_table.dynamodb1.arn
  sensitive   = false
}
# <<< archly:node:dynamodb1 <<<

# >>> archly:node:s3_images >>>
output "s3_images_arn" {
  description = "Bucket ARN"
  value       = aws_s3_bucket.s3_images.arn
  sensitive   = false
}
# <<< archly:node:s3_images <<<