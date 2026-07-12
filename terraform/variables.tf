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

# >>> archly:group:vnet1 >>>
variable "vnet1_address_space" {
  description = "Address space for VNet 'VNet'"
  type        = string
  default     = "10.0.0.0/16"
}
# <<< archly:group:vnet1 <<<

# >>> archly:group:subnet_public >>>
variable "subnet_public_address_prefix" {
  description = "Address prefix for subnet 'Public Subnet' (must fall within the VNet's address space)"
  type        = string
}
# <<< archly:group:subnet_public <<<

# >>> archly:group:subnet_private >>>
variable "subnet_private_address_prefix" {
  description = "Address prefix for subnet 'Private Subnet' (must fall within the VNet's address space)"
  type        = string
}
# <<< archly:group:subnet_private <<<

# >>> archly:group:subnet_data >>>
variable "subnet_data_address_prefix" {
  description = "Address prefix for subnet 'Data Subnet' (must fall within the VNet's address space)"
  type        = string
}
# <<< archly:group:subnet_data <<<

# >>> archly:node:afd1 >>>
variable "afd1_cdn_profile_name" {
  description = "Name of an existing azurerm_cdn_profile"
  type        = string
}

variable "afd1_origin_host_name" {
  description = "Hostname of the origin this CDN serves"
  type        = string
}
# <<< archly:node:afd1 <<<

# >>> archly:node:container_apps >>>
variable "container_apps_container_image" {
  description = "Container image to deploy, e.g. myrepo/app:latest"
  type        = string
}

variable "container_apps_environment_id" {
  description = "Id of an existing Container Apps environment"
  type        = string
}
# <<< archly:node:container_apps <<<

# >>> archly:node:sql1 >>>
variable "sql1_administrator_login" {
  description = "Administrator login"
  type        = string
}

variable "sql1_administrator_password" {
  description = "Administrator password -- supply via TF_VAR_sql1_administrator_password, never commit"
  type        = string
  sensitive   = true
}
# <<< archly:node:sql1 <<<

# >>> archly:node:sql_failover >>>
variable "sql_failover_administrator_login" {
  description = "Administrator login"
  type        = string
}

variable "sql_failover_administrator_password" {
  description = "Administrator password -- supply via TF_VAR_sql_failover_administrator_password, never commit"
  type        = string
  sensitive   = true
}
# <<< archly:node:sql_failover <<<

# >>> archly:node:service_bus >>>
variable "service_bus_servicebus_namespace_id" {
  description = "Id of an existing Service Bus namespace"
  type        = string
}
# <<< archly:node:service_bus <<<

# >>> archly:node:blob_storage >>>
variable "blob_storage_storage_account_name" {
  description = "Globally-unique storage account name (lowercase, no dashes)"
  type        = string
}
# <<< archly:node:blob_storage <<<