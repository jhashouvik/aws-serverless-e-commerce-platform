

# >>> archly:node:cache1 >>>
# Secrets manager entry for ElastiCache
resource "aws_secretsmanager_secret" "cache1_auth" {
  name = "cache1-cache-auth-token"
}
resource "aws_secretsmanager_secret_version" "cache1_auth" {
  secret_id     = aws_secretsmanager_secret.cache1_auth.id
  secret_string = var.cache1_auth_token
}
# <<< archly:node:cache1 <<<

# >>> archly:node:rds1 >>>
# Secrets manager entry for RDS Multi-AZ
resource "aws_secretsmanager_secret" "rds1_credentials" {
  name = "rds1-db-credentials"
}
resource "aws_secretsmanager_secret_version" "rds1_credentials" {
  secret_id = aws_secretsmanager_secret.rds1_credentials.id
  secret_string = jsonencode({
    username = var.rds1_username
    password = var.rds1_password
    endpoint = aws_db_instance.rds1.endpoint
  })
}
# <<< archly:node:rds1 <<<
