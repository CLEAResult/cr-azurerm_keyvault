provider "azurerm" {
  version         = "1.30.1"
  subscription_id = var.subscription_id
  tenant_id       = var.tenant_id
}

resource "random_string" "suffix" {
  length  = 8
  special = false
  upper   = false
}

data "azurerm_client_config" "current" {}

resource "azurerm_resource_group" "rg" {
  name     = format("rg-%s", random_string.suffix.result)
  location = var.location
}

module "keyvault" {
  source                   = "../../"
  rgid                     = var.rgid
  environment              = var.environment
  location                 = var.location
  subscription_id          = var.subscription_id
  tenant_id                = var.tenant_id
  rg_name                  = azurerm_resource_group.rg.name
  servicePrincipleId       = data.azurerm_client_config.current.service_principal_object_id
}

# Create a secret in the new key vault as test validation


# Dummy secret
resource "azurerm_key_vault_secret" "test" {
  name     = "secret-string"
  value    = "testsecret"
  key_vault_id = module.keyvault.id[0]

  tags = {
    environment = "Production"
  }
}

# Dummy certificate
resource "azurerm_key_vault_certificate" "test" {
  name     = "generated-cert"
  key_vault_id = module.keyvault.id[0]

  certificate_policy {
    issuer_parameters {
      name = "Self"
    }

    key_properties {
      exportable = true
      key_size   = 2048
      key_type   = "RSA"
      reuse_key  = true
    }

    lifetime_action {
      action {
        action_type = "AutoRenew"
      }

      trigger {
        days_before_expiry = 30
      }
    }

    secret_properties {
      content_type = "application/x-pkcs12"
    }

    x509_certificate_properties {
      # Server Authentication = 1.3.6.1.5.5.7.3.1
      # Client Authentication = 1.3.6.1.5.5.7.3.2
      extended_key_usage = ["1.3.6.1.5.5.7.3.1"]

      key_usage = [
        "cRLSign",
        "dataEncipherment",
        "digitalSignature",
        "keyAgreement",
        "keyCertSign",
        "keyEncipherment",
      ]

      subject_alternative_names {
        dns_names = ["internal.contoso.com", "domain.hello.world"]
      }

      subject            = "CN=hello-world"
      validity_in_months = 12
    }
  }
}
