provider "azurerm" {
  features {}
}

resource "azurerm_resource_group" "main" {
  name     = "${var.prefix}-resources"
  location = var.location
  tags = {
    udacity : "project1"
  }
}

resource "azurerm_virtual_network" "main" {
  name                = "${var.prefix}-vnet"
  location            = azurerm_resource_group.main.location
  resource_group_name = azurerm_resource_group.main.name
  address_space       = ["10.0.0.0/22"]
  tags = {
    udacity : "project1"
  }
  depends_on = [
    azurerm_resource_group.main,
  ]
}

resource "azurerm_subnet" "internal" {
  name                 = "${var.prefix}-subnet"
  resource_group_name  = azurerm_resource_group.main.name
  virtual_network_name = azurerm_virtual_network.main.name
  address_prefixes     = ["10.0.1.0/24"]
  depends_on = [
    azurerm_resource_group.main,
    azurerm_virtual_network.main
  ]
}
# Default rule is deny all internet access
# and allow all traffic from the subnet.
resource "azurerm_network_security_group" "main" {
  name                = "${var.prefix}-nsg"
  location            = azurerm_resource_group.main.location
  resource_group_name = azurerm_resource_group.main.name
  tags = {
    udacity : "project1"
  }
  depends_on = [
    azurerm_resource_group.main
  ]
}
# Associate the NSG with the subnet.
resource "azurerm_subnet_network_security_group_association" "main" {
  subnet_id                 = azurerm_subnet.internal.id
  network_security_group_id = azurerm_network_security_group.main.id
  depends_on = [
    azurerm_resource_group.main,
    azurerm_subnet.internal,
    azurerm_network_security_group.main
  ]
}
resource "azurerm_network_interface" "main" {
  count               = var.number_of_vms # create NIC for each VM
  name                = "${var.prefix}-nic-${count.index}"
  location            = azurerm_resource_group.main.location
  resource_group_name = azurerm_resource_group.main.name

  ip_configuration {
    name                          = "${var.prefix}-ipconfig"
    subnet_id                     = azurerm_subnet.internal.id
    private_ip_address_allocation = "Dynamic"
  }
  tags = {
    udacity : "project1"
  }
  depends_on = [
    azurerm_resource_group.main
  ]
}
resource "azurerm_public_ip" "main" {
  name                = "${var.prefix}-public-ip"
  location            = azurerm_resource_group.main.location
  resource_group_name = azurerm_resource_group.main.name
  allocation_method   = "Static"
  sku                 = "Standard" # Need to be standard to load balancer support availablity zones - ref: https://docs.microsoft.com/en-us/azure/load-balancer/load-balancer-standard-availability-zones
  tags = {
    udacity : "project1"
  }
}
resource "azurerm_lb" "main" {
  name                = "${var.prefix}-lb"
  resource_group_name = azurerm_resource_group.main.name
  location            = azurerm_resource_group.main.location
  sku                 = "Standard" # Need to be standard to load balancer support availablity zones - ref: https://docs.microsoft.com/en-us/azure/load-balancer/load-balancer-standard-availability-zones
  frontend_ip_configuration {
    name                 = "${var.prefix}-lb-frontend"
    public_ip_address_id = azurerm_public_ip.main.id
  }

  tags = {
    "udacity" = "project1"
  }
}
resource "azurerm_lb_backend_address_pool" "main" {
  name            = "${var.prefix}-backend-pool"
  loadbalancer_id = azurerm_lb.main.id
}
resource "azurerm_network_interface_backend_address_pool_association" "main" {
  count                   = var.number_of_vms
  network_interface_id    = azurerm_network_interface.main[count.index].id
  ip_configuration_name   = azurerm_network_interface.main[count.index].ip_configuration[0].name
  backend_address_pool_id = azurerm_lb_backend_address_pool.main.id
  depends_on = [
    azurerm_network_interface.main,
    azurerm_lb_backend_address_pool.main
  ]
}
resource "azurerm_availability_set" "main" {
  name                        = "${var.prefix}-avset"
  location                    = azurerm_resource_group.main.location
  resource_group_name         = azurerm_resource_group.main.name
  platform_fault_domain_count = 2
  tags = {
    udacity : "project1"
  }
}
# custom image that we deploy by packer
data "azurerm_image" "packerimage" {
  name                = var.packer_image_name
  resource_group_name = var.packer_image_resource_group_name
}


resource "azurerm_virtual_machine" "main" {
  count                         = var.number_of_vms # create multiple VMs
  name                          = "${var.prefix}-vm-${count.index}"
  resource_group_name           = azurerm_resource_group.main.name
  location                      = azurerm_resource_group.main.location
  vm_size                       = "Standard_B1s"
  delete_os_disk_on_termination = true
  
  network_interface_ids = [
    element(azurerm_network_interface.main.*.id, count.index)
  ]
  os_profile {
    computer_name  = "hostname"
    admin_username = var.username
    admin_password = var.password
  }

  storage_image_reference {
    id = data.azurerm_image.packerimage.id
  }

  storage_os_disk {
    name              = "${var.prefix}-osdisk-${count.index}"
    create_option     = "FromImage"
    caching           = "ReadWrite"
    managed_disk_type = "Standard_LRS"
  }
  os_profile_linux_config {
    disable_password_authentication = false
  }
  tags = {
    udacity : "project1"
  }
  # Ensure that delete in correct order
  depends_on = [
    azurerm_network_interface.main,
    azurerm_network_interface_backend_address_pool_association.main,
  ]
}
