terraform {
  required_version = ">= 1.9.0"

  required_providers {
    azurerm = {
      source  = "hashicorp/azurerm"
      version = "~> 4.0"
    }
  }
}

# Authentication comes from the Azure CLI login.
# The subscription comes from ARM_SUBSCRIPTION_ID (set by lab.env), never from this file.
provider "azurerm" {
  features {}
}
