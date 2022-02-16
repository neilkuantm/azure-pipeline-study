// remote backend use storage account.
terraform {
  backend "azurerm" {
    resource_group_name  = "StorageAccount-ResourceGroup-neil"
    storage_account_name = "azurepipelineremoteneil"
    container_name       = "tfstate"
    key                  = "prod.terraform.tfstate"
  }
}

// use azurerm provider.
provider "azurerm" {
  features {}
}

// create demo resource group.
resource "azurerm_resource_group" "demo_terraform_rg" {
  name     = "demo-terraform-rg"
  location = "Japan East"
}