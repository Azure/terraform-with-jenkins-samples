variable "terraform_resource_group" {
  description = "Azure resource group"
  default     = "vm-RG"
  type        = "string"
}

variable "terraform_azure_region" {
  description = "Azure region for deployment"
  default     = "North Europe"
  type        = "string"
}

variable "terraform_vm_name" {
  description = "VM name"
  default     = "vm"
  type        = "string"
}