provider "azurerm" {
  features {}
}

resource "azurerm_resource_group" "demo_terraform_rg" {
  name     = "demo-terraform-rg"
  location = "Japan East"
}