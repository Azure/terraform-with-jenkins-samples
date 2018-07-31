variable "terraform_resource_group" {
  description = "Azure resource group"
  default     = "vmss-RG"
  type        = "string"
}

variable "terraform_azure_region" {
  description = "Azure region for deployment"
  default     = "North Europe"
  type        = "string"
}

variable "terraform_vmss_count" {
  description = "Instance count"
  default     = 3
}

variable "terraform_vmss_name" {
  description = "VMSS name"
  default     = "vmss"
  type        = "string"
}

variable "terraform_image_id" {
  description = "VM image id"
  type        = "string"
}
variable "terraform_client" {
  description = "Client name"
  default     = "someclient"
  type        = "string"
}