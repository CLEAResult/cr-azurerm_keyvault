output "vault_uri" {
  value = "${data.azurerm_key_vault.vault.vault_uri}"
}