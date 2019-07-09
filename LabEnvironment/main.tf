resource "azurerm_resource_group" "TFWS_Labstations" {
  name     = "${var.rg_labstation}"
  location = "${var.location}"
}

resource "azurerm_virtual_network" "TFWS_Labstations-vn" {
  name                = "${var.rg_labstation}-vn"
  address_space       = ["${var.vn_cidr}"]
  location            = "${azurerm_resource_group.TFWS_Labstations.location}"
  resource_group_name = "${azurerm_resource_group.TFWS_Labstations.name}"
 }

 resource "azurerm_subnet" "subnet-labstations" {
  name                 = "${var.rg_labstation}-vn-subnet-labstations"
  resource_group_name  = "${azurerm_resource_group.TFWS_Labstations.name}"
  virtual_network_name = "${azurerm_virtual_network.TFWS_Labstations-vn.name}"
  address_prefix       = "${var.vn_subnetlabstations_cidr}"
}