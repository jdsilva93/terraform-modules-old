resource "azurerm_log_analytics_workspace" "law01" {
    name                = "law-${var.environment}"
    location            = var.location
    resource_group_name = var.resourcegroup
    sku                 = "PerGB2018"
    retention_in_days   = 30
}



resource "azurerm_log_analytics_solution" "example" {
    solution_name         = "VMInsights"
    location              = var.location
    resource_group_name   = var.resourcegroup
    workspace_resource_id = azurerm_log_analytics_workspace.law01.id
    workspace_name        = azurerm_log_analytics_workspace.law01.name

    plan {
    publisher = "Microsoft"
    product   = "OMSGallery/ContainerInsights"
    }
}