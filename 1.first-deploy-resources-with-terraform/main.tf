provider "azurerm" {
  features {}
}

# resource "azurerm_resource_group" "main" {
#   name     = "${var.prefix}-resources"
#   location = var.location
# }

resource "azurerm_virtual_network" "main" {
  name                = "${var.prefix}-network"
  address_space       = ["10.0.0.0/22"]
  # location            = azurerm_resource_group.main.location
  # resource_group_name = azurerm_resource_group.main.name
  resource_group_name             = "${var.resource_group_name}"
  location                        = var.location
}

resource "azurerm_subnet" "internal" {
  name                 = "internal"
  # resource_group_name  = azurerm_resource_group.main.name
  resource_group_name             = "${var.resource_group_name}"
  virtual_network_name = azurerm_virtual_network.main.yesname
  address_prefixes     = ["10.0.2.0/24"]
}

resource "azurerm_network_interface" "main" {
  name                = "${var.prefix}-nic"
  # resource_group_name = azurerm_resource_group.main.name
  # location            = azurerm_resource_group.main.location
  resource_group_name             = "${var.resource_group_name}"
  location                        = var.location

  ip_configuration {
    name                          = "internal"
    subnet_id                     = azurerm_subnet.internal.id
    private_ip_address_allocation = "Dynamic"
  }
}

resource "azurerm_linux_virtual_machine" "main" {
  name                            = "${var.prefix}-vm"
  # resource_group_name             = azurerm_resource_group.main.name
  # location                        = azurerm_resource_group.main.location
  resource_group_name             = "${var.resource_group_name}"
  location                        = var.location
  # size                            = "Standard_D2s_v3"
  size                            = "Standard_B1s"
  admin_username                  = "${var.username}"
  admin_password                  = "${var.password}"
  disable_password_authentication = false
  network_interface_ids = [
    azurerm_network_interface.main.id,
  ]

  source_image_reference {
    publisher = "Canonical"
    offer     = "UbuntuServer"
    sku       = "18.04-LTS"
    version   = "latest"
  }

  os_disk {
    storage_account_type = "Standard_LRS"
    caching              = "ReadWrite"
  }
}