variable "rgname" {
    default = "rg-weu-dev-app-jb"
}
variable "location" {
    default = "West Europe"
}
variable "vnetname" {
    default = "vnet-weu-dev-jb"
}
variable "vnetcidr" {
    default = "10.20.0.0/16"
}
variable "subnetname" {
    default = "snet-weu-dev-jb"
}
variable "subnetcidr" {
    default = ["10.20.1.0/24"]
}
variable "vmname" {
    default = "vm-weu-dev-jb"
}
variable "nsgname" {
    default = "nsg-snet-weu-dev-jb"
}
variable "nsgrulename" {
    default = "AllowRDPInbound"
}
variable "priority" {
    default = "1000"
}
variable "direction" {
    default = "Inbound"
}
variable "access" {
    default = "Allow"
}
variable "protocol" {
    default = "Tcp"
}
variable "sourceport" {
    default = "*"
}
variable "destinationport" {
    default = "3389"
}
variable "sourceaddress" {
    default = "*"
}
variable "destinationaddress" {
    default = "*"
}




