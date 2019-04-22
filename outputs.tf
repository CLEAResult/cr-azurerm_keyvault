output "vault_uri" {
  value = "${data.azurerm_key_vault.test.vault_uri}"
}