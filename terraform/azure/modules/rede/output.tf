output "subnet_vnet10_id" {
    value = "${azurerm_vnet10_subnet.subnet.id}"
}

output "subnet_vnet20_id" {
    value = "${azurerm_subnet.subnet.id}"
}