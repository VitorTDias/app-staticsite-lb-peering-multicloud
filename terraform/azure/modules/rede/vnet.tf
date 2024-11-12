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

resource "azurerm_subnet" "subnet_vnet10" {
    name                 = "subnet_vnet10"
    resource_group_name  = "${var.rg_name}"
    virtual_network_name = azurerm_virtual_network.vnet10.name
    address_prefixes     = ["${var.subnet_vnet10_cidr}"]
}

resource "azurerm_subnet" "subnet_vnet20" {
    name                 = "subnet_vnet20"
    resource_group_name  = "${var.rg_name}"
    virtual_network_name = azurerm_virtual_network.vnet20.name
    address_prefixes     = ["${var.subnet_vnet20_cidr}"]
}

resource "azurerm_network_security_group" "nsgvnet10" {
    name                = "nsgvnet10"
    location            = "${var.location}"
    resource_group_name = "${var.rg_name}"
    security_rule {
        name                       = "Inbound-Internet-HTTP"
        priority                   = 1001
        direction                  = "Inbound"
        access                     = "Allow"
        protocol                   = "Tcp"
        source_port_range          = "*"
        destination_port_range     = "80"
        source_address_prefix      = "Internet"
        destination_address_prefix = "*"
    }
    security_rule {
        name                       = "Inbound-Internet-SSH"
        priority                   = 1011
        direction                  = "Inbound"
        access                     = "Allow"
        protocol                   = "Tcp"
        source_port_range          = "*"
        destination_port_range     = "22"
        source_address_prefix      = "Internet"
        destination_address_prefix = "*"
    }
}

resource "azurerm_network_security_group" "nsgvnet20" {
    name                = "nsgvnet20"
    location            = "${var.location}"
    resource_group_name = "${var.rg_name}"
    security_rule {
        name                       = "Inbound-Internet-All"
        priority                   = 1001
        direction                  = "Inbound"
        access                     = "Deny"
        protocol                   = "*"
        source_port_range          = "*"
        destination_port_range     = "*"
        source_address_prefix      = "Internet"
        destination_address_prefix = "*"
    }
}

resource "azurerm_subnet_network_security_group_association" "nsgsnvnet10pub" {
    subnet_id                 = azurerm_subnet.subnet_vnet10_id.id
    network_security_group_id = azurerm_network_security_group.nsgvnet10.id
}

resource "azurerm_subnet_network_security_group_association" "nsgsnvnet20priv" {
    subnet_id                 = azurerm_subnet.subnet_vnet20_id.id
    network_security_group_id = azurerm_network_security_group.nsgvnet20.id
    depends_on                = [ azurerm_subnet.subnet_vnet20_id ]
}