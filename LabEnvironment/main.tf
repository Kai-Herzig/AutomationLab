resource "azurerm_resource_group" "TFWS_Labstations" {
  name     = "${var.rg_labstation}"
  location = "${var.location}"
}

resource "azurerm_virtual_network" "TFWS_Labstations-vn" {
  name                = "${var.rg_labstation}-vn"
  address_space       = ["${var.vn_labstations_cidr}"]
  location            = "${azurerm_resource_group.TFWS_Labstations.location}"
  resource_group_name = "${azurerm_resource_group.TFWS_Labstations.name}"
 }

 resource "azurerm_subnet" "subnet" {
  name                 = "${var.rg_labstation}-vn-subnet-labstations"
  resource_group_name  = "${azurerm_resource_group.TFWS_Labstations.name}"
  virtual_network_name = "${azurerm_virtual_network.TFWS_Labstations-vn.name}"
  address_prefix       = "${var.vn_subnetlabstations_cidr}"
}

resource "azurerm_network_interface" "nics" {
  count               = "${var.vm_count}"
  name                = "${var.labstation_prefix}-nic-${count.index}"
  location            = "${azurerm_resource_group.TFWS_Labstations.location}"
  resource_group_name = "${azurerm_resource_group.TFWS_Labstations.name}"

  ip_configuration {
    name                          = "labipconfiguration1"
    subnet_id                     = "${azurerm_subnet.subnet.id}"
    private_ip_address_allocation = "Dynamic"
  }
}