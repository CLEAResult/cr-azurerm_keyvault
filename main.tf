resource "azurerm_key_vault" "vault" {
  name                            = format("%s%03d", local.name, count.index + 1)
  count                           = var.num
  resource_group_name             = var.rg_name
  location                        = var.location
  tenant_id                       = var.tenant_id
  enabled_for_deployment          = var.allowVMUsage
  enabled_for_template_deployment = var.allowARMUsage

  sku {
    name = var.tier
  }

  access_policy {
    tenant_id = var.tenant_id
    object_id = var.servicePrincipleId

    key_permissions = [
      "create",
      "get",
    ]

    secret_permissions = [
      "set",
      "get",
      "delete",
    ]

    network_acls {
      default_action = "Deny"
      bypass         = "AzureServices"
    }

  }

  tags = {
    InfrastructureAsCode = "True"
  }
}

