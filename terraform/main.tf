terraform {
  required_version = ">= 1.5.0"
  required_providers {
    azurerm = {
      source  = "hashicorp/azurerm"
      version = "~> 3.0"
    }
    azuread = {
      source  = "hashicorp/azuread"
      version = "~> 2.0"
    }
  }

  # Recommended for production: store state remotely with locking, e.g.
  # backend "azurerm" {
  #   resource_group_name  = "tfstate-rg"
  #   storage_account_name = "mytfstateaccount"
  #   container_name        = "tfstate"
  #   key                   = "diagram-agent.tfstate"
  # }
}

provider "azurerm" {
  features {}
}

provider "azuread" {}

# >>> archly:group:vnet1 >>>
# VNet (network boundary)

resource "azurerm_virtual_network" "vnet1" {
  name                = "vnet1"
  resource_group_name = var.resource_group_name
  location            = var.location
  address_space       = [var.vnet1_address_space]
}
# <<< archly:group:vnet1 <<<

# >>> archly:group:subnet_public >>>
# Public Subnet (subnet within 'VNet')

resource "azurerm_subnet" "subnet_public" {
  name                 = "subnet_public"
  resource_group_name  = var.resource_group_name
  virtual_network_name = azurerm_virtual_network.vnet1.name
  address_prefixes     = [var.subnet_public_address_prefix]
}
# <<< archly:group:subnet_public <<<

# >>> archly:group:subnet_private >>>
# Private Subnet (subnet within 'VNet')

resource "azurerm_subnet" "subnet_private" {
  name                 = "subnet_private"
  resource_group_name  = var.resource_group_name
  virtual_network_name = azurerm_virtual_network.vnet1.name
  address_prefixes     = [var.subnet_private_address_prefix]
}
# <<< archly:group:subnet_private <<<

# >>> archly:group:subnet_data >>>
# Data Subnet (subnet within 'VNet')

resource "azurerm_subnet" "subnet_data" {
  name                 = "subnet_data"
  resource_group_name  = var.resource_group_name
  virtual_network_name = azurerm_virtual_network.vnet1.name
  address_prefixes     = [var.subnet_data_address_prefix]
}
# <<< archly:group:subnet_data <<<

# >>> archly:node:afd1 >>>
# Azure Front Door (cdn)
resource "azurerm_cdn_endpoint" "afd1" {
  name                = "afd1"
  profile_name        = var.afd1_cdn_profile_name
  location            = var.location
  resource_group_name = var.resource_group_name
  origin {
    name      = "afd1-origin"
    host_name = var.afd1_origin_host_name
  }
}
# <<< archly:node:afd1 <<<

# >>> archly:node:agw1 >>>
# App Gateway WAF (load_balancer) -- belongs to subnet 'Public Subnet' (see resource id 'subnet_public' above; wire this resource's subnet/network args to it manually)
resource "azurerm_lb" "agw1" {
  name                = "agw1"
  resource_group_name = var.resource_group_name
  location            = var.location
  sku                 = "Standard"
}
# <<< archly:node:agw1 <<<

# >>> archly:node:container_apps >>>
# Container Apps (compute.container) -- belongs to subnet 'Private Subnet' (see resource id 'subnet_private' above; wire this resource's subnet/network args to it manually)
resource "azurerm_container_app" "container_apps" {
  name                         = "container_apps"
  resource_group_name          = var.resource_group_name
  container_app_environment_id = var.container_apps_environment_id
  revision_mode                = "Single"
  template {
    container {
      name   = "container_apps"
      image  = var.container_apps_container_image
      cpu    = 0.5
      memory = "1Gi"
    }
  }
}
# <<< archly:node:container_apps <<<

# >>> archly:node:sql1 >>>
# Azure SQL Primary (database.relational) -- belongs to subnet 'Data Subnet' (see resource id 'subnet_data' above; wire this resource's subnet/network args to it manually)
resource "azurerm_postgresql_flexible_server" "sql1" {
  name                   = "sql1"
  resource_group_name    = var.resource_group_name
  location               = var.location
  administrator_login    = var.sql1_administrator_login
  administrator_password = var.sql1_administrator_password
  sku_name               = "B_Standard_B1ms"
  storage_mb             = 32768
  version                = "15"
}
# <<< archly:node:sql1 <<<

# >>> archly:node:sql_failover >>>
# Azure SQL Failover (database.relational) -- belongs to subnet 'Data Subnet' (see resource id 'subnet_data' above; wire this resource's subnet/network args to it manually)
resource "azurerm_postgresql_flexible_server" "sql_failover" {
  name                   = "sql_failover"
  resource_group_name    = var.resource_group_name
  location               = var.location
  administrator_login    = var.sql_failover_administrator_login
  administrator_password = var.sql_failover_administrator_password
  sku_name               = "B_Standard_B1ms"
  storage_mb             = 32768
  version                = "15"
}
# <<< archly:node:sql_failover <<<

# >>> archly:node:redis1 >>>
# Cache for Redis (database.cache) -- belongs to subnet 'Data Subnet' (see resource id 'subnet_data' above; wire this resource's subnet/network args to it manually)
resource "azurerm_redis_cache" "redis1" {
  name                = "redis1"
  resource_group_name = var.resource_group_name
  location            = var.location
  capacity            = 1
  family              = "C"
  sku_name            = "Standard"
  # Access keys are generated by Azure and available as sensitive outputs
  # (azurerm_redis_cache.redis1.primary_access_key) -- never set them as input.
}
# <<< archly:node:redis1 <<<

# >>> archly:node:service_bus >>>
# Service Bus (queue)
resource "azurerm_servicebus_queue" "service_bus" {
  name         = "service_bus"
  namespace_id = var.service_bus_servicebus_namespace_id
}
# <<< archly:node:service_bus <<<

# >>> archly:node:blob_storage >>>
# Blob Storage (storage.object)
resource "azurerm_storage_account" "blob_storage" {
  name                     = var.blob_storage_storage_account_name
  resource_group_name      = var.resource_group_name
  location                 = var.location
  account_tier             = "Standard"
  account_replication_type = "LRS"
  min_tls_version          = "TLS1_2"
}
# <<< archly:node:blob_storage <<<

# >>> archly:node:key_vault >>>
# Key Vault (secrets)
resource "azurerm_key_vault" "key_vault" {
  name                       = "key_vault"
  resource_group_name        = var.resource_group_name
  location                   = var.location
  tenant_id                  = var.tenant_id
  sku_name                   = "standard"
  purge_protection_enabled   = true
  soft_delete_retention_days = 90
}
# <<< archly:node:key_vault <<<