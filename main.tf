# Req Provider Block
terraform {
  required_providers {
    azurerm = {
      source  = "hashicorp/azurerm"
      version = "=2.46.0"
    }
  }
}

# Configure Azure Provider
provider "azurerm" {
  features {}
}


# Create a resource group if it doesn't exist
data "azurerm_resource_group" "rg" {
  name = "gitlab_rg"
}

# Create public IPs
resource "azurerm_public_ip" "public_ip" {
  name                = "gitlab_prod_public_ip"
  location            = data.azurerm_resource_group.rg.location
  resource_group_name = data.azurerm_resource_group.rg.name
  allocation_method   = "Dynamic" #Static
  #  sku                 = "Basic" # standard
  # ip_version          = "IPv4"
  # availability_zone = "1" # 2 3 Zone-Redundant
  tags = {
    environment = "prod"
  }
}

# Create virtual network
resource "azurerm_virtual_network" "vnet" {
  name                = "gitlab_prod_vnet"
  address_space       = ["10.0.0.0/16"]
  location            = data.azurerm_resource_group.rg.location
  resource_group_name = data.azurerm_resource_group.rg.name

  tags = {
    environment = "prod"
  }
}

# Create subnet
resource "azurerm_subnet" "subnet" {
  name                 = "gitlab_prod_subnet"
  resource_group_name  = data.azurerm_resource_group.rg.name
  virtual_network_name = azurerm_virtual_network.vnet.name
  address_prefixes     = ["10.0.1.0/24"]
}



module "prod_server" {
  source                       = "./modules/gitlabServer"
  location                     = "West Europe"
  environment                  = "gitlab_prod"
  gitlab_resource_group_name   = data.azurerm_resource_group.rg.name
  network_security_group_name  = "nsgprod019"
  network_interface_name       = "nicprod019"
  subnet_id                    = azurerm_subnet.subnet.id
  public_ip_id                 = azurerm_public_ip.public_ip.id
  linux_virtual_machine_name   = "linuxvm019"
  instance_size                = "Standard_DS1_v2"
  os_disk_name                 = "gitlab_prod_os_disk"
  os_disk_caching_type         = "ReadWrite"
  os_disk_storage_account_type = "Premium_LRS"
  computer_name                = "gitlabVmProd"
  admin_username               = "azureuser"
  ssh_public_key_file_location = "gitlab_public.pub"
}

output "instance_obj" {
  value     = module.prod_server.gitlab_server_instance
  sensitive = true
}

output "instance_details" {
  value = " ${module.prod_server.vm_ip} \n ${module.prod_server.vm_id}"
}

