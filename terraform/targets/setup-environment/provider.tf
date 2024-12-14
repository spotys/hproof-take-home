terraform {
  required_providers {
    azuread = {
      source  = "hashicorp/azuread"
      version = "3.0.2"
    }

    azurerm = {
      source  = "hashicorp/azurerm"
      version = "4.13.0"
    }

    google = {
      source  = "hashicorp/google"
      version = "6.13.0"
    }
  }

  backend "azurerm" {
    resource_group_name  = "terraform-shared-rg"
    storage_account_name = "terraformsharedsa"
    container_name       = "tfstate"
  }
}

provider "azuread" {}

provider "azurerm" {
  features {
    key_vault {
      purge_soft_deleted_secrets_on_destroy = true
      recover_soft_deleted_secrets          = true
    }
  }
}

provider "google" {
  region = "us-west1"
}
