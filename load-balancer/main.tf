resource "azurerm_lb" "lb" {
    name                 = var.lbname
    location             = var.location
    resource_group_name  = var.resourcegroup
    sku                  = var.lbsku
    frontend_ip_configuration {
        name                           = "fip-${var.lbname}"
        subnet_id                      = var.subnetid
        private_ip_address_allocation  = "Static"
        private_ip_address             = var.lbprivip
        zones                          = ["1", "2", "3"]
    }
}


resource "azurerm_lb_backend_address_pool" "lb_backend" {
    name                = "bep-${var.lbname}"
    loadbalancer_id     = azurerm_lb.lb.id
    depends_on          = [
        azurerm_lb.lb
    ]
}

resource "azurerm_lb_probe" "lb_probe" {
    name                = "probe-${var.lbname}"
    port                = var.lbprobeport
    protocol            = var.lbprobeprotocol
    loadbalancer_id     = azurerm_lb.lb.id
    request_path        = var.lbproberequestpath
    depends_on          = [
        azurerm_lb.lb
    ]
}

resource "azurerm_lb_rule" "lb_rule" {
    name                                = var.lbrulename
    protocol                            = var.lbruleprotocol
    frontend_port                       = var.lbrulefrtport
    backend_port                        = var.lbrulebckport
    loadbalancer_id                     = azurerm_lb.lb.id
    backend_address_pool_ids            = [azurerm_lb_backend_address_pool.lb_backend.id]
    frontend_ip_configuration_name      = "fip-${var.lbname}"
    probe_id                            = azurerm_lb_probe.lb_probe.id
    depends_on                          = [
        azurerm_lb.lb,
        azurerm_lb_backend_address_pool.lb_backend
    ]
}