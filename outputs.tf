output "id" {
  value = azurerm_key_vault.vault.*.id
}

output "vault_uri" {
  value = azurerm_key_vault.vault.*.vault_uri
}
