resource "azurerm_network_interface" "main" {
    name                = "nic-${var.vmname}"
    location            = var.location
    resource_group_name = var.resourcegroup

    ip_configuration {
        name                          = "IPConfig"
        subnet_id                     = var.subnetid
        private_ip_address_allocation = "Dynamic"
    }
}

resource "azurerm_virtual_machine" "vm" {
    name                  = var.vmname
    location              = var.location
    resource_group_name   = var.resourcegroup
    network_interface_ids = [azurerm_network_interface.main.id]
    vm_size               = "Standard_DS1_v2"

    storage_image_reference {
        publisher = var.vmimgpublisher
        offer     = var.vmimgoffer
        sku       = var.vmimgsku
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

resource "azurerm_virtual_machine_extension" "vm_extension_install_iis" {
    name                       = "vm_extension_install_iis"
    virtual_machine_id         = azurerm_virtual_machine.vm.id
    publisher                  = "Microsoft.Compute"
    type                       = "CustomScriptExtension"
    type_handler_version       = "1.8"
    auto_upgrade_minor_version = true

    settings = <<SETTINGS
    {
        "commandToExecute":"powershell Add-WindowsFeature Web-Server; powershell Add-Content -Path \"C:\\inetpub\\wwwroot\\Default.htm\" -Value $($env:computername)"
    }
SETTINGS
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