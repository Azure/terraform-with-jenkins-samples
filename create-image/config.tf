variable "terraform_resource_group" {
  description = "Azure resource group"
  type        = "string"
}

variable "terraform_azure_region" {
  description = "Azure region for deployment"
  type        = "string"
}

variable "terraform_image_name" {
  description = "VM name"
  type        = "string"
}

variable "terraform_vm_id" {
  description = "VM id"
  type        = "string"
}