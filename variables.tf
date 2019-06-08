variable "rgid" {
  description = "RGID used for naming"
}

variable "location" {
  default     = "southcentralus"
  description = "Location for resources to be created"
}

variable "num" {
  default = 1
}

variable "tier" {
  default     = "standard"
  description = "The tier for Azure Key Vault.  Valid values are: Standard and Premium."
}

variable "name_prefix" {
  default     = ""
  description = "Allows users to override the standard naming prefix.  If left as an empty string, the standard naming conventions will apply."
}

variable "environment" {
  default     = "dev"
  description = "Environment used in naming lookups"
}

variable "rg_name" {
  description = "Default resource group name that the Azure Key Vault will be created in."
}

variable "service_principle_id" {
  description = "Service Principle ID for access to key vault"
}

variable "tenant_id" {
  description = "Prompt for tenant ID"
}

variable "allow_vm_usage" {
  default     = false
  description = "Boolean flag to specify whether Azure Virtual Machines are permitted to retrieve certificates stored as secrets from the key vault. Defaults to false."
}

variable "allow_arm_usage" {
  default     = false
  description = "Boolean flag to specify whether Azure Resource Manager is permitted to retrieve secrets from the key vault. Defaults to false."
}

variable "allow_storage_usage" {
  default     = false
  description = "Boolean flag to specify whether Azure Disk Encryption is permitted to retrieve secrets from the vault and unwrap keys. Defaults to false."
}

variable "network_acls" {
  default     = {}
  description = "Boolean flag to specify whether Azure Disk Encryption is permitted to retrieve secrets from the vault and unwrap keys. Defaults to false."
}

variable application_id" {
  default     = ""
  description = "The object ID of an Application in Azure Active Directory." 
}

variable "certificate_permissions" {
  default     = []
  description = "List of certificate permissions, must be one or more from the following: backup, create, delete, deleteissuers, get, getissuers, import, list, listissuers, managecontacts, manageissuers, purge, recover, restore, setissuers and update."
}

variable "key_permissions" {
  default = []
  description = "List of key permissions, must be one or more from the following: backup, create, decrypt, delete, encrypt, get, import, list, purge, recover, restore, sign, unwrapKey, update, verify and wrapKey."
}

variable "secret_permissions" {
  default = []
  description = "List of secret permissions, must be one or more from the following: backup, delete, get, list, purge, recover, restore and set."
}

variable "storage_permissions" {
  default = []
  description = "List of storage permissions, must be one or more from the following: backup, delete, deletesas, get, getsas, list, listsas, purge, recover, regeneratekey, restore, set, setsas and update."
}

# Compute default name values
locals {
  env_id = lookup(module.naming.env-map, var.environment, "env")
  type   = lookup(module.naming.type-map, "azurerm_key_vault", "typ")

  default_rgid        = var.rgid != "" ? var.rgid : "norgid"
  default_name_prefix = format("c%s%s", local.default_rgid, local.env_id)

  name_prefix = var.name_prefix != "" ? var.name_prefix : local.default_name_prefix
  name        = format("%s%s", local.name_prefix, local.type)
}

# This module provides a data map output to lookup naming standard references
module "naming" {
  source = "git::https://github.com/CLEAResult/cr-azurerm-naming.git?ref=v1.1.0"
}

