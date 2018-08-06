resource "azurerm_resource_group" "test" {
  name     = "${var.terraform_resource_group}"
  location = "${var.terraform_azure_region}"

  tags {
    client = "${var.terraform_client}"
  }
}


resource "azurerm_virtual_network" "test" {
  name                = "${format("%s-%s", var.terraform_resource_group, "vnet")}"
  address_space       = ["10.0.0.0/16"]
  location            = "${var.terraform_azure_region}"
  resource_group_name = "${azurerm_resource_group.test.name}"
}

resource "azurerm_subnet" "test" {
  name                 = "default"
  resource_group_name  = "${azurerm_resource_group.test.name}"
  virtual_network_name = "${azurerm_virtual_network.test.name}"
  address_prefix       = "10.0.2.0/24"
}

resource "azurerm_public_ip" "test" {
  name                         = "${var.terraform_vmss_name}"
  location                     = "${var.terraform_azure_region}"
  resource_group_name          = "${azurerm_resource_group.test.name}"
  public_ip_address_allocation = "dynamic"
}

resource "azurerm_lb" "test" {
  name                = "${var.terraform_vmss_name}"
  location            = "${var.terraform_azure_region}"
  resource_group_name = "${azurerm_resource_group.test.name}"

  frontend_ip_configuration {
    name                 = "PublicIPAddress"
    public_ip_address_id = "${azurerm_public_ip.test.id}"
  }
}

resource "azurerm_lb_backend_address_pool" "bpepool" {
  resource_group_name = "${azurerm_resource_group.test.name}"
  loadbalancer_id     = "${azurerm_lb.test.id}"
  name                = "BackEndAddressPool"
}

resource "azurerm_lb_nat_pool" "lbnatpool" {
  count                          = "${var.terraform_vmss_count}"
  resource_group_name            = "${azurerm_resource_group.test.name}"
  name                           = "ssh"
  loadbalancer_id                = "${azurerm_lb.test.id}"
  protocol                       = "Tcp"
  frontend_port_start            = 50000
  frontend_port_end              = 50119
  backend_port                   = 22
  frontend_ip_configuration_name = "PublicIPAddress"
}

resource "azurerm_virtual_machine_scale_set" "test" {
  name                = "${var.terraform_vmss_name}"
  location            = "${var.terraform_azure_region}"
  resource_group_name = "${azurerm_resource_group.test.name}"
  upgrade_policy_mode = "Manual"
  overprovision       = false
  sku {
    name     = "Standard_DS2_v2"
    tier     = "Standard"
    capacity = "${var.terraform_vmss_count}"
  }

  storage_profile_image_reference {
    id = "${var.terraform_image_id}"
  }

  storage_profile_os_disk {
    create_option     = "FromImage"
    os_type           = "Linux"
    managed_disk_type = "Premium_LRS"
    name=""
  }

  os_profile {
    computer_name_prefix = "${var.terraform_vmss_name}"
    admin_username       = "azureuser"
    admin_password       = "SomePassword.100"
  }

  os_profile_linux_config {
    disable_password_authentication = true

    ssh_keys {
      path     = "/home/azureuser/.ssh/authorized_keys"
      key_data = "${file("~/.ssh/id_rsa.pub")}"
    }
  }

  network_profile {
    name    = "terraformnetworkprofile"
    primary = true

    ip_configuration {
      name                                   = "TestIPConfiguration"
      subnet_id                              = "${azurerm_subnet.test.id}"
      load_balancer_backend_address_pool_ids = ["${azurerm_lb_backend_address_pool.bpepool.id}"]
      load_balancer_inbound_nat_rules_ids    = ["${element(azurerm_lb_nat_pool.lbnatpool.*.id, count.index)}"]
    }
  }

  extension {
    name                 = "CustomScript"
    publisher            = "Microsoft.Azure.Extensions"
    type                 = "CustomScript"
    type_handler_version = "2.0"

    settings = <<SETTINGS
    {
        "commandToExecute": "hostname"
    }
    SETTINGS
  }

  tags {
    client = "${var.terraform_client}"
  }
}