variable "key_vault_id" {
  description = "Id of the Key Vault secrets should be written to (see the 'secrets' resource below if present)"
  type        = string
}

variable "location" {
  description = "Azure region to deploy into"
  type        = string
  default     = "eastus"
}

variable "resource_group_name" {
  description = "Existing resource group to deploy into"
  type        = string
}

variable "tenant_id" {
  description = "Azure AD tenant id"
  type        = string
}

# >>> archly:group:data1 >>>
variable "data1_availability_zone" {
  description = "Availability zone for subnet 'Data Subnet'"
  type        = string
}

variable "data1_cidr_block" {
  description = "CIDR block for subnet 'Data Subnet' (must not overlap sibling subnets)"
  type        = string
}
# <<< archly:group:data1 <<<

# >>> archly:group:private1 >>>
variable "private1_availability_zone" {
  description = "Availability zone for subnet 'Private Subnet'"
  type        = string
}

variable "private1_cidr_block" {
  description = "CIDR block for subnet 'Private Subnet' (must not overlap sibling subnets)"
  type        = string
}
# <<< archly:group:private1 <<<

# >>> archly:group:public1 >>>
variable "public1_availability_zone" {
  description = "Availability zone for subnet 'Public Subnet'"
  type        = string
}

variable "public1_cidr_block" {
  description = "CIDR block for subnet 'Public Subnet' (must not overlap sibling subnets)"
  type        = string
}
# <<< archly:group:public1 <<<

# >>> archly:group:vpc1 >>>
variable "vpc1_cidr_block" {
  description = "CIDR block for VPC 'VPC'"
  type        = string
  default     = "10.0.0.0/16"
}
# <<< archly:group:vpc1 <<<

# >>> archly:node:alb1 >>>
variable "alb1_subnet_ids" {
  description = "List of subnet ids to place the load balancer in"
  type        = list(string)
  default     = [aws_subnet.public1.id]
}
# <<< archly:node:alb1 <<<

# >>> archly:node:cache1 >>>
variable "cache1_auth_token" {
  description = "Redis AUTH token -- supply via TF_VAR_cache1_auth_token, never commit"
  type        = string
  sensitive   = true
}

variable "cache1_node_type" {
  description = "ElastiCache node type"
  type        = string
  default     = "cache.t3.micro"
}
# <<< archly:node:cache1 <<<

# >>> archly:node:cdn1 >>>
variable "cdn1_origin_domain_name" {
  description = "Domain name of the origin this CDN serves (ALB/S3/etc.)"
  type        = string
}
# <<< archly:node:cdn1 <<<

# >>> archly:node:dns1 >>>
variable "dns1_domain_name" {
  description = "Domain name managed by this zone, e.g. example.com"
  type        = string
}
# <<< archly:node:dns1 <<<

# >>> archly:node:ec2_auto1 >>>
variable "ec2_auto1_ami" {
  description = "AMI id to boot (region-specific, no safe default)"
  type        = string
}

variable "ec2_auto1_instance_type" {
  description = "EC2 instance type"
  type        = string
  default     = "t3.micro"
}
# <<< archly:node:ec2_auto1 <<<

# >>> archly:node:lambda1 >>>
variable "lambda1_execution_role_arn" {
  description = "ARN of an existing IAM role with lambda execution permissions"
  type        = string
}

variable "lambda1_handler" {
  description = "Function handler entrypoint"
  type        = string
  default     = "index.handler"
}

variable "lambda1_package_s3_bucket" {
  description = "S3 bucket containing the deployment package"
  type        = string
}

variable "lambda1_package_s3_key" {
  description = "S3 key of the deployment package zip"
  type        = string
}

variable "lambda1_runtime" {
  description = "Lambda runtime"
  type        = string
  default     = "nodejs20.x"
}
# <<< archly:node:lambda1 <<<

# >>> archly:node:rds1 >>>
variable "rds1_engine" {
  description = "Database engine"
  type        = string
  default     = "postgres"
}

variable "rds1_instance_class" {
  description = "RDS instance class"
  type        = string
  default     = "db.t3.micro"
}

variable "rds1_password" {
  description = "Master password -- supply via TF_VAR_rds1_password, never commit"
  type        = string
  sensitive   = true
}

variable "rds1_username" {
  description = "Master username"
  type        = string
}
# <<< archly:node:rds1 <<<

# >>> archly:node:s3_images >>>
variable "s3_images_bucket_name" {
  description = "Globally-unique S3 bucket name"
  type        = string
}
# <<< archly:node:s3_images <<<
