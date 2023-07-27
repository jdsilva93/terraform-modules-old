resource "azurerm_resource_group" "rg" {
    name     = var.rgname
    location = var.location
}

resource "azurerm_virtual_network" "vnet" {
    name                = var.vnetname
    resource_group_name = azurerm_resource_group.rg.name
    location            = var.location
    address_space       = [var.vnetcidr]
}

resource "azurerm_subnet" "subnet" {
    virtual_network_name = azurerm_virtual_network.vnet.name
    resource_group_name  = azurerm_resource_group.rg.name
    name                 = var.subnetname
    address_prefixes     = var.subnetcidr
}

resource "azurerm_network_interface" "main" {
    name                = "nic-${var.vmname}"
    location            = var.location
    resource_group_name = azurerm_resource_group.rg.name

    ip_configuration {
        name                          = "IPConfig"
        subnet_id                     = azurerm_subnet.subnet.id
        private_ip_address_allocation = "Dynamic"
    }
}

resource "azurerm_virtual_machine" "vm" {
    name                  = var.vmname
    location              = var.location
    resource_group_name   = azurerm_resource_group.rg.name
    network_interface_ids = [azurerm_network_interface.main.id]
    vm_size               = "Standard_DS1_v2"

    storage_image_reference {
        publisher = "cognosys"
        offer     = "ubuntu-1604-lts"
        sku       = "ubuntu-16-04-lts"
        version   = "latest"
    }
    storage_os_disk {
        name              = "osdisk-${var.vmname}"
        caching           = "ReadWrite"
        create_option     = "FromImage"
        managed_disk_type = "Standard_LRS"
    }
    os_profile {
        computer_name  = var.vmname
        admin_username = "vmazureadmin"
        admin_password = "FEf'4f'£f9gj3T39&"
    }
    os_profile_windows_config {
        provision_vm_agent = true
    }
    tags = {}
}

resource "azurerm_dev_test_global_vm_shutdown_schedule" "shutdown" {
    virtual_machine_id = azurerm_virtual_machine.vm.id
    location           = var.location
    enabled            = true

    daily_recurrence_time = "1900"
    timezone              = "GMT Standard Time"

    notification_settings {
        enabled         = false
    }
}

resource "azurerm_network_security_group" "nsg" {
    name                = var.nsgname
    location            = var.location
    resource_group_name = azurerm_resource_group.rg.name
}

resource "azurerm_subnet_network_security_group_association" "nsg-association" {
    subnet_id                 = azurerm_subnet.subnet.id
    network_security_group_id = azurerm_network_security_group.nsg.id
}

resource "azurerm_network_security_rule" "rule" {
    name                        = var.nsgrulename
    priority                    = var.priority
    direction                   = var.direction
    access                      = var.access
    protocol                    = var.protocol
    source_port_range           = var.sourceport
    destination_port_range      = var.destinationport
    source_address_prefix       = var.sourceaddress
    destination_address_prefix  = var.destinationaddress
    resource_group_name         = azurerm_resource_group.rg.name
    network_security_group_name = azurerm_network_security_group.nsg.name
}
