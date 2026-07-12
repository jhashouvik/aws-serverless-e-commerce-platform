# >>> archly:node:key_vault >>>
output "key_vault_id" {
  description = "Key Vault id (reference this as key_vault_id elsewhere)"
  value       = azurerm_key_vault.key_vault.id
  sensitive   = false
}
# <<< archly:node:key_vault <<<