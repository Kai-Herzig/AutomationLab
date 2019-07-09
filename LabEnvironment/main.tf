resource "azurerm_resource_group" "TFWS_Labstations" {
  name     = "${var.rg_labstations}"
  location = "${var.location}"
}

resource "azurerm_virtual_network" "TFWS_Labstations-vn" {
  name                = "${var.rg_labstations}-vn"
  address_space       = ["${var.vn_cidr}"]
  location            = "${azurerm_resource_group.TFWS_Labstations.location}"
  resource_group_name = "${azurerm_resource_group.TFWS_Labstations.name}"
 }