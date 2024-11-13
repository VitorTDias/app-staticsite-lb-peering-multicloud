///////secuity group

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

resource "azurerm_subnet_network_security_group_association" "nsgsnvnet10puba" {
    subnet_id                 = "${var.subnet_vnet10a_id}"
    network_security_group_id = azurerm_network_security_group.nsgvnet10.id
}

resource "azurerm_subnet_network_security_group_association" "nsgsnvnet10pubb" {
    subnet_id                 =  "${var.subnet_vnet10b_id}"
    network_security_group_id = azurerm_network_security_group.nsgvnet10.id
}

resource "azurerm_subnet_network_security_group_association" "nsgsnvnet20priv" {
    subnet_id                 =  "${var.subnet_vnet20_id}"
    network_security_group_id = azurerm_network_security_group.nsgvnet20.id
    depends_on                = [ azurerm_subnet.subnet_vnet20 ]
}


// PUBLICO

resource "azurerm_availability_set" "as_public" {
    name                = "as-public"
    location            = "${var.location}"
    resource_group_name = "${var.rg_name}"
}

/////// VM 1 PUB

resource "azurerm_public_ip" "vm01_pip_public" {
    name                = "vm01-pip-public"
    location            = "${var.location}"
    resource_group_name = "${var.rg_name}"
    allocation_method   = "Static"
    domain_name_label   = "vm01-pip-public"
}

resource "azurerm_network_interface" "vm01_nic_public" {
    name                = "vm01-nic-public"
    location            = "${var.location}"
    resource_group_name = "${var.rg_name}"
    ip_configuration {
        name                          = "vm01-ipconfig-public"
        subnet_id                     = azurerm_subnet.subnet_vnet10a.id
        private_ip_address_allocation = "Dynamic"
        public_ip_address_id          = azurerm_public_ip.vm01_pip_public.id
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
        custom_data    = "${base64encode(data.template_file.cloud_init.rendered)}"
    }
    os_profile_linux_config {
        disable_password_authentication = false
    }
}

///// VM 2 PUB


resource "azurerm_public_ip" "vm02_pip_public" {
    name                = "vm02-pip-public"
    location            = "${var.location}"
    resource_group_name = "${var.rg_name}"
    allocation_method   = "Static"
    domain_name_label   = "vm02-pip-public"
}

resource "azurerm_network_interface" "vm02_nic_public" {
    name                = "vm02-nic-public"
    location            = "${var.location}"
    resource_group_name = "${var.rg_name}"
    ip_configuration {
        name                          = "vm01-ipconfig-public"
        subnet_id                     = azurerm_subnet.subnet_vnet10b.id
        private_ip_address_allocation = "Dynamic"
        public_ip_address_id          = azurerm_public_ip.vm02_pip_public.id
    }
}


resource "azurerm_virtual_machine" "vm02_public" {
    name                             = "vm02-public"
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
        custom_data    = "${base64encode(data.template_file.cloud_init.rendered)}"
    }
    os_profile_linux_config {
        disable_password_authentication = false
    }
}

data "template_file" "cloud_init" {
    template = "${file("./modules/compute/init/cloud_init.sh")}"
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
        subnet_id                     = azurerm_subnet.subnet_vnet20.id
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
        custom_data    = "${base64encode(data.template_file.cloud_init.rendered)}"
    
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