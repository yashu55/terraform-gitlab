
variable "location" {
  type        = string
  description = "location in Azure"
}
variable "environment" {
  type        = string
  description = "Environment Type: Prod, Dev etc"
}

variable "gitlab_resource_group_name" {
  type        = string
  description = "gitlab_resource_group_name in Azure"
}

variable "network_security_group_name" {
  type        = string
  description = "NSG name in Azure"
}

variable "network_interface_name" {
  type        = string
  description = "NIC name in Azure"
}

variable "subnet_id" {
  type        = string
  description = "subnet_id for instance"
}

variable "public_ip_id" {
  type        = string
  description = "public_ip_id for instance"
}

variable "linux_virtual_machine_name" {
  type        = string
  description = "Linux VM name in Azure"
}

variable "instance_size" {
  type        = string
  description = "Size of azure instance"
}

variable "os_disk_name" {
  type        = string
  description = "os_disk_caching_type"
}

variable "os_disk_caching_type" {
  type        = string
  description = "os_disk_caching_type"
}

variable "os_disk_storage_account_type" {
  type        = string
  description = "os_disk_caching_type"
}

variable "computer_name" {
  type        = string
  description = "computer_name"
}

variable "admin_username" {
  type        = string
  default     = "azureuser"
  description = "admin_username"
}

variable "ssh_public_key_file_location" {
  type = string
  description = "ssh_public_key_file_location"
}
