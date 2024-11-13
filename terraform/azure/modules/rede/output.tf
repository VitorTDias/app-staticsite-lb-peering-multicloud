output "subnet_vnet10a_id" {
    value = "${azurerm_subnet.subnet_vnet10a.id}"
}

output "subnet_vnet10b_id" {
    value = "${azurerm_subnet.subnet_vnet10b.id}"
}

output "subnet_vnet20_id" {
    value = "${azurerm_subnet.subnet_vnet20.id}"
}

output "vnet10_id" {
    value = "${azurerm_virtual_network.vnet10.id}"
}

output "vnet20_id" {
    value = "${azurerm_virtual_network.vnet20.id}"
}