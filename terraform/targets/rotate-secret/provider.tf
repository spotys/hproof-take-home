terraform {
  required_providers {
    google = {
      source  = "hashicorp/google"
      version = "6.13.0"
    }
    azurerm = {
      source  = "hashicorp/azurerm"
      version = "4.13.0"
    }
  }

  backend "azurerm" {
    resource_group_name  = "terraform-shared-rg"
    storage_account_name = "terraformsharedsa"
    container_name       = "tfstate"
  }
}

provider "google" {
  project = var.gcp.project_id
  region  = var.gcp.region
}

provider "azurerm" {
  features {
    key_vault {
      purge_soft_deleted_secrets_on_destroy = true
      recover_soft_deleted_secrets          = true
    }
  }
}
