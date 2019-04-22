resource "azurerm_key_vault" "vault" {
  name                = "${local.name}${format("%03d", count.index + 1)}"
  count               = "${var.count}"
  resource_group_name = "${var.rg_name}"
  location            = "${var.location}"
  tenant_id           = "${var.tenant_id}"

  sku {
    name = "${var.tier}"
  }

  access_policy {
    tenant_id = "${var.tenant_id}"
    object_id = "${var.servicePrincipleId}"

    key_permissions = [
      "create",
      "get",
    ]

    secret_permissions = [
      "set",
      "get",
      "delete",
    ]
  }

  tags = {
    InfrastructureAsCode = "True"
  }
}
