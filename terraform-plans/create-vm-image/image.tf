resource "azurerm_resource_group" "test" {
  name     = "${var.terraform_resource_group}"
  location = "${var.terraform_azure_region}"
}

resource "azurerm_image" "test" {
  name = "${var.terraform_image_name}"
  location = "${var.terraform_azure_region}"
  resource_group_name = "${azurerm_resource_group.test.name}"
  source_virtual_machine_id = "${var.terraform_vm_id}"
}