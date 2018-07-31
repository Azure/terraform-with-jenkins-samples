resource "azurerm_resource_group" "test" {
  name     = "${var.terraform_resource_group}"
  location = "${var.terraform_azure_region}"
}

resource "azurerm_virtual_network" "test" {
  name                = "gpuvmvnet"
  address_space       = ["10.0.0.0/16"]
  location            = "${var.terraform_azure_region}"
  resource_group_name = "${var.terraform_resource_group}"
}

resource "azurerm_subnet" "test" {
  name                 = "gpusubnet"
  resource_group_name  = "${azurerm_resource_group.test.name}"
  virtual_network_name = "${azurerm_virtual_network.test.name}"
  address_prefix       = "10.0.2.0/24"
}

resource "azurerm_public_ip" "test" {
  name                         = "${var.terraform_vm_name}"
  location                     = "${var.terraform_azure_region}"
  resource_group_name          = "${azurerm_resource_group.test.name}"
  public_ip_address_allocation = "dynamic"
  
}

resource "azurerm_network_interface" "test" {
  name                = "${var.terraform_vm_name}"
  location            = "${var.terraform_azure_region}"
  resource_group_name = "${azurerm_resource_group.test.name}"

  ip_configuration {
    name                          = "testconfiguration1"
    subnet_id                     = "${azurerm_subnet.test.id}"
    private_ip_address_allocation = "dynamic"
    public_ip_address_id          =  "${azurerm_public_ip.test.id}"
  }
}


resource "azurerm_virtual_machine" "test" {
  name                  = "${var.terraform_vm_name}"
  location              = "${var.terraform_azure_region}"
  resource_group_name   = "${azurerm_resource_group.test.name}"
  network_interface_ids = ["${azurerm_network_interface.test.id}"]
  vm_size               = "Standard_NV6"

  delete_os_disk_on_termination = true

  storage_os_disk {
    create_option     = "FromImage"
    os_type           = "Linux"
    managed_disk_type = "Standard_LRS"
    name=""
  }

  os_profile {
    computer_name = "testvm"
    admin_username       = "azureuser"
  }

  os_profile_linux_config {
    disable_password_authentication = true

    ssh_keys {
      path     = "/home/azureuser/.ssh/authorized_keys"
      key_data = "${file("~/.ssh/id_rsa.pub")}"
    }
  }
}