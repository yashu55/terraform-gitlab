output "vm_id" {
  value = azurerm_linux_virtual_machine.gitlab_server.id
}

output "vm_ip" {
  value = azurerm_linux_virtual_machine.gitlab_server.public_ip_address
}

output "gitlab_server_instance" {
  value       = azurerm_linux_virtual_machine.gitlab_server
  description = "Instance details that is provisioned"
  sensitive   = true
}


