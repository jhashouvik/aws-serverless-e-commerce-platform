# >>> archly:node:sql1 >>>
# Secrets manager entry for Azure SQL Primary
resource "azurerm_key_vault_secret" "sql1_password" {
  name         = "sql1-db-password"
  value        = var.sql1_administrator_password
  key_vault_id = var.key_vault_id
}
# <<< archly:node:sql1 <<<

# >>> archly:node:sql_failover >>>
# Secrets manager entry for Azure SQL Failover
resource "azurerm_key_vault_secret" "sql_failover_password" {
  name         = "sql_failover-db-password"
  value        = var.sql_failover_administrator_password
  key_vault_id = var.key_vault_id
}
# <<< archly:node:sql_failover <<<