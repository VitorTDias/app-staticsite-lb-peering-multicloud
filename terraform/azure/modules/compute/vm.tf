// PUBLICO

resource "azurerm_availability_set" "as_public" {
    name                = "as-public"
    location            = "${var.location}"
    resource_group_name = "${var.rg_name}"
}

resource "azurerm_network_interface" "vm01_nic_public" {
    name                = "vm01-nic-public"
    location            = "${var.location}"
    resource_group_name = "${var.rg_name}"
    ip_configuration {
        name                          = "vm01-ipconfig-public"
        subnet_id                     = "${var.subnet_vnet10_id}"
        private_ip_address_allocation = "Dynamic"
        public_ip_address_id          = azurerm_public_ip.lb.id
    }
}

resource "azurerm_network_interface" "vm02_nic_public" {
    name                = "vm01-nic-public"
    location            = "${var.location}"
    resource_group_name = "${var.rg_name}"
    ip_configuration {
        name                          = "vm01-ipconfig-public"
        subnet_id                     = "${var.subnet_vnet10_id}"
        private_ip_address_allocation = "Dynamic"
        public_ip_address_id          = azurerm_public_ip.lb.id
    }
}

resource "azurerm_virtual_machine" "vm01_public" {
    name                             = "vm01-public"
    location                         = "${var.location}"
    resource_group_name              = "${var.rg_name}"
    network_interface_ids            = [azurerm_network_interface.vm01_nic_public.id]
    availability_set_id              = azurerm_availability_set.as_public.id
    vm_size                          = "Standard_D2s_v3"
    delete_os_disk_on_termination    = true
    delete_data_disks_on_termination = true
    storage_image_reference {
        publisher = "Canonical"
        offer     = "0001-com-ubuntu-server-jammy"
        sku       = "22_04-lts"
        version   = "latest"
    }
    storage_os_disk {
        name              = "vm01-os-disk-public"
        caching           = "ReadWrite"
        create_option     = "FromImage"
        managed_disk_type = "Standard_LRS"
    }
    os_profile {
        computer_name  = "vm01-public"
        admin_username = "azureuser"
        admin_password = "Password1234!"
        user_data      = "${base64encode(data.template_file.cloud_init.rendered)}"
    }
    os_profile_linux_config {
        disable_password_authentication = false
    }
}

resource "azurerm_virtual_machine" "vm02_public" {
    name                             = "vm0-public"
    location                         = "${var.location}"
    resource_group_name              = "${var.rg_name}"
    network_interface_ids            = [azurerm_network_interface.vm02_nic_public.id]
    availability_set_id              = azurerm_availability_set.as_public.id
    vm_size                          = "Standard_D2s_v3"
    delete_os_disk_on_termination    = true
    delete_data_disks_on_termination = true
    storage_image_reference {
        publisher = "Canonical"
        offer     = "0001-com-ubuntu-server-jammy"
        sku       = "22_04-lts"
        version   = "latest"
    }
    storage_os_disk {
        name              = "vm01-os-disk-public"
        caching           = "ReadWrite"
        create_option     = "FromImage"
        managed_disk_type = "Standard_LRS"
    }
    os_profile {
        computer_name  = "vm01-public"
        admin_username = "azureuser"
        admin_password = "Password1234!"
        user_data      = "${base64encode(data.template_file.cloud_init.rendered)}"
    }
    os_profile_linux_config {
        disable_password_authentication = false
    }
}

//PRIVADO

resource "azurerm_availability_set" "as_private" {
    name                = "as-private"
    location            = "${var.location}"
    resource_group_name = "${var.rg_name}"
}

resource "azurerm_network_interface" "vm02_nic_private" {
    name                = "vm02-nic-private"
    location            = "${var.location}"
    resource_group_name = "${var.rg_name}"
    ip_configuration {
        name                          = "vm02-ipconfig-private"
        subnet_id                     = "${var.subnet_vnet20_id}"
        private_ip_address_allocation = "Dynamic"
    }
}

resource "azurerm_virtual_machine" "vm02_private" {
    name                             = "vm02-private"
    location                         = "${var.location}"
    resource_group_name              = "${var.rg_name}"
    network_interface_ids            = [azurerm_network_interface.vm02_nic_private.id]
    availability_set_id              = azurerm_availability_set.as_private.id
    vm_size                          = "Standard_D2s_v3"
    delete_os_disk_on_termination    = true
    delete_data_disks_on_termination = true
    storage_image_reference {
        publisher = "Canonical"
        offer     = "0001-com-ubuntu-server-jammy"
        sku       = "22_04-lts"
        version   = "latest"
    }
    storage_os_disk {
        name              = "vm02-os-disk-private"
        caching           = "ReadWrite"
        create_option     = "FromImage"
        managed_disk_type = "Standard_LRS"
    }
    os_profile {
        computer_name  = "vm02-private"
        admin_username = "azureuser"
        admin_password = "Password1234!"
        user_data      = "${base64encode(data.template_file.cloud_init.rendered)}"
    
    }
    os_profile_linux_config {
        disable_password_authentication = false
    }
}

## LOAD BALANCER

resource "azurerm_public_ip" "lb" {
    name                = "lb"
    location            = "${var.location}"
    resource_group_name = "${var.rg_name}"
    allocation_method   = "Static"
    domain_name_label   = "${var.fqdn}"
}

resource "azurerm_lb" "lb" {
    name                = "lb"
    location            = "${var.location}"
    resource_group_name = "${var.rg_name}"
    frontend_ip_configuration {
        name                 = "lb"
        public_ip_address_id = azurerm_public_ip.lb.id
    }
}

resource "azurerm_lb_backend_address_pool" "lb" {
    name            = "lb"
    loadbalancer_id = azurerm_lb.lb.id
}

resource "azurerm_lb_rule" "lb" {
    name                           = "HTTP"
    loadbalancer_id                = azurerm_lb.lb.id
    protocol                       = "Tcp"
    frontend_port                  = 80
    backend_port                   = 80
    frontend_ip_configuration_name = "lb"
    backend_address_pool_ids       = [azurerm_lb_backend_address_pool.lb.id]
    load_distribution              = "SourceIPProtocol"
}

resource "azurerm_network_interface_backend_address_pool_association" "vm01" {
    ip_configuration_name   = "vm01"
    network_interface_id    = azurerm_network_interface.vm01_nic_public.id
    backend_address_pool_id = azurerm_lb_backend_address_pool.lb.id
}

resource "azurerm_network_interface_backend_address_pool_association" "vm02" {
    ip_configuration_name   = "vm02"
    network_interface_id    = azurerm_network_interface.vm02_nic_public.id
    backend_address_pool_id = azurerm_lb_backend_address_pool.lb.id
}