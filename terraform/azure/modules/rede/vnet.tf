resource "azurerm_virtual_network" "vnet10" {
    name                = "vnet10"
    location            = "${var.location}"
    resource_group_name = "${var.rg_name}"
    address_space       = ["${var.vnet10_cidr}"]
}

resource "azurerm_virtual_network" "vnet20" {
    name                = "vnet20"
    location            = "${var.location}"
    resource_group_name = "${var.rg_name}"
    address_space       = ["${var.vnet20_cidr}"]
}

resource "azurerm_virtual_network_peering" "vnet10-to-vnet20" {
  name                      = "vnet10-to-vnet20"
  resource_group_name       = "${var.rg_name}"
  virtual_network_name      = azurerm_virtual_network.vnet10.name
  remote_virtual_network_id = azurerm_virtual_network.vnet20.id
}

resource "azurerm_virtual_network_peering" "vnet20-to-vnet10" {
  name                      = "vnet20-to-vnet10"
  resource_group_name       = "${var.rg_name}"
  virtual_network_name      = azurerm_virtual_network.vnet20.name
  remote_virtual_network_id = azurerm_virtual_network.vnet10.id
}

resource "azurerm_subnet" "subnet_vnet10a" {
    name                 = "subnet_vnet10a"
    resource_group_name  = "${var.rg_name}"
    virtual_network_name = azurerm_virtual_network.vnet10.name
    address_prefixes     = ["${var.subnet_vnet10a_cidr}"]
}

resource "azurerm_subnet" "subnet_vnet10b" {
    name                 = "subnet_vnet10b"
    resource_group_name  = "${var.rg_name}"
    virtual_network_name = azurerm_virtual_network.vnet10.name
    address_prefixes     = ["${var.subnet_vnet10b_cidr}"]
}

resource "azurerm_subnet" "subnet_vnet20" {
    name                 = "subnet_vnet20"
    resource_group_name  = "${var.rg_name}"
    virtual_network_name = azurerm_virtual_network.vnet20.name
    address_prefixes     = ["${var.subnet_vnet20_cidr}"]
}

