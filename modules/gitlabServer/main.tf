
# Create Network Security Group and rule
resource "azurerm_network_security_group" "nsg" {
  name                = var.network_security_group_name
  location            = var.location
  resource_group_name = var.gitlab_resource_group_name

  security_rule {
    name                       = "SSH"
    priority                   = 1001 # 100 and 4096 Unique for every rule
    direction                  = "Inbound"
    access                     = "Allow"
    protocol                   = "Tcp"
    source_port_range          = "*"
    destination_port_range     = "22"
    source_address_prefix      = "*"
    destination_address_prefix = "*"
  }

  tags = {
    environment = var.environment
  }
}

# Create network interface
resource "azurerm_network_interface" "nic" {
  name                = var.network_interface_name
  location            = var.location
  resource_group_name = var.gitlab_resource_group_name

  ip_configuration {
    name                          = "${var.network_interface_name}_Configuration"
    subnet_id                     = var.subnet_id
    private_ip_address_allocation = "Dynamic"
    public_ip_address_id          = var.public_ip_id
  }

  tags = {
    environment = var.environment
  }
}

# Connect the security group to the network interface
resource "azurerm_network_interface_security_group_association" "association" {
  network_interface_id      = azurerm_network_interface.nic.id
  network_security_group_id = azurerm_network_security_group.nsg.id
}

# Create (and display) an SSH key
# resource "tls_private_key" "gitlab_ssh" {
#   algorithm = "RSA"
#   rsa_bits  = 4096
# }

# Create virtual machine
resource "azurerm_linux_virtual_machine" "gitlab_server" {
  name                  = var.linux_virtual_machine_name
  location              = var.location
  resource_group_name   = var.gitlab_resource_group_name
  network_interface_ids = [azurerm_network_interface.nic.id]
  size                  = var.instance_size

  os_disk {
    name                 = var.os_disk_name
    caching              = var.os_disk_caching_type
    storage_account_type = var.os_disk_storage_account_type
  }

  source_image_reference {
    publisher = "RedHat"
    offer     = "RHEL"
    sku       = "8.1"
    version   = "latest"
  }

  computer_name                   = var.computer_name
  admin_username                  = var.admin_username
  disable_password_authentication = true

  admin_ssh_key {
    username   = var.admin_username
    public_key = file("gitlab_public.pub")
  }

  tags = {
    environment = var.environment
  }

  # provisioner "remote-exec" {
  #   inline = [
  #     "sudo yum install git -y"
  #   ]
  #   on_failure = fail
  # }
}
