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
    resource_group_name         = var.resource_group
    network_security_group_name = var.nsgname
}