resource "azurerm_resource_group" "test" {
  name     = "${var.terraform_resource_group}"
  location = "${var.terraform_azure_region}"
}

resource "azurerm_virtual_network" "test" {
  name                = "${format("%s-%s", var.terraform_resource_group, "vnet")}"
  address_space       = ["10.0.0.0/16"]
  location            = "${var.terraform_azure_region}"
  resource_group_name = "${azurerm_resource_group.test.name}"
}

resource "azurerm_subnet" "test" {
  name                 = "subnet"
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
  vm_size               = "Standard_DS2_v2"

  delete_os_disk_on_termination = true

  storage_image_reference {
    publisher = "Canonical"
    offer     = "UbuntuServer"
    sku       = "16.04-LTS"
    version   = "latest"
  }

  storage_os_disk {
    name              = "${format("%s-%s", var.terraform_vm_name, "osdisk1")}"
    caching           = "ReadWrite"
    create_option     = "FromImage"
    managed_disk_type = "Premium_LRS"
  }

  os_profile {
    computer_name = "${var.terraform_vm_name}"
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