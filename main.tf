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

resource "random_password" "password" {
  length           = 12
  special          = true
  override_special = "_%@"
}

module "network" {
  source              = "Azure/network/azurerm"
  resource_group_name = azurerm_resource_group.demo_terraform_rg.name
  subnet_prefixes     = ["10.0.1.0/24"]
  subnet_names        = ["subnet1"]

  depends_on = [azurerm_resource_group.demo_terraform_rg]
}

module "linuxservers" {
  source              = "Azure/compute/azurerm"
  resource_group_name = azurerm_resource_group.demo_terraform_rg.name
  vm_os_simple        = "UbuntuServer"
  public_ip_dns       = ["linsimplevmips"] // change to a unique name per datacenter region
  vnet_subnet_id      = module.network.vnet_subnets[0]
  enable_ssh_key      = false
  depends_on = [azurerm_resource_group.demo_terraform_rg]
  admin_password      = random_password.password.result
}

output "linux_vm_public_name" {
  value = module.linuxservers.public_ip_dns_name
}

output "random_password" {
  value = random_password.password.result
  sensitive = true
}