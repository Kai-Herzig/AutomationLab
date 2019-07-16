#######-RG & Network Configuration
resource "azurerm_resource_group" "main" {
  name     = "tfws-${var.participant}-${var.rg_name}"
  location = "${var.location}"
}
fgf
resource "azurerm_virtual_network" "main" {
  name                = "${var.rg_name}"
  address_space       = ["${var.vn_cidr}"]
  location            = "${azurerm_resource_group.main.location}"
  resource_group_name = "${azurerm_resource_group.main.name}"
}

resource "azurerm_subnet" "subnetwfe" {
  name                 = "${var.subnetwfe_name}"
  resource_group_name  = "${azurerm_resource_group.main.name}"
  virtual_network_name = "${azurerm_virtual_network.main.name}"
  address_prefix       = "${var.subnetwfe_cidr}"
}
resource "azurerm_subnet" "subnetsql" {
  name                 = "${var.subnetsql_name}"
  resource_group_name  = "${azurerm_resource_group.main.name}"
  virtual_network_name = "${azurerm_virtual_network.main.name}"
  address_prefix       = "${var.subnetsql_cidr}"
}
resource "azurerm_subnet" "subnetad" {
  name                 = "${var.subnetad_name}"
  resource_group_name  = "${azurerm_resource_group.main.name}"
  virtual_network_name = "${azurerm_virtual_network.main.name}"
  address_prefix       = "${var.subnetad_cidr}"
}

#######-WFE Virtual Machine Configuration
resource "azurerm_network_interface" "vm_wfe" {
  name                = "${var.vm_wfe_name}-nic"
  location            = "${azurerm_resource_group.main.location}"
  resource_group_name = "${azurerm_resource_group.main.name}"

  ip_configuration {
    name                          = "${var.vm_wfe_name}-ipconf"
    subnet_id                     = "${azurerm_subnet.subnetwfe.id}"
    private_ip_address_allocation = "Dynamic"
  }
}
resource "azurerm_virtual_machine" "vm_wfe" {
  name                  = "${var.vm_wfe_name}-vm"
  location              = "${azurerm_resource_group.main.location}"
  resource_group_name   = "${azurerm_resource_group.main.name}"
  network_interface_ids = ["${azurerm_network_interface.vm_wfe.id}"]
  vm_size               = "${var.vm_standardvm_size}"

  # Uncomment this line to delete the OS disk automatically when deleting the VM
  delete_os_disk_on_termination = true


  # Uncomment this line to delete the data disks automatically when deleting the VM
  delete_data_disks_on_termination = true

  storage_image_reference {
    publisher = "${var.vm_standard_publisher}"
    offer     = "${var.vm_standard_offer}"
    sku       = "${var.vm_standard_sku}"
    version   = "${var.vm_standard_version}"
  }
  storage_os_disk {
    name              = "${var.vm_wfe_name}-disk"
    caching           = "ReadWrite"
    create_option     = "FromImage"
    managed_disk_type = "${var.vm_standard_disktype}"
  }
  storage_data_disk {
    name = "${var.vm_wfe_name}-datadisk"
    create_option = "Empty"
    disk_size_gb = "128"
    lun = "2"
    managed_disk_type = "${var.vm_standard_disktype}"
  }
  os_profile {
    computer_name  = "${var.vm_wfe_name}"
    admin_username = "labadmin"
    admin_password = "Welcome2019!"
  }
  os_profile_windows_config{
  }
}
#######-\

#######-SQL Virtual Machine Configuration
resource "azurerm_network_interface" "vm_sql" {
  name                = "${var.vm_sql_name}-nic"
  location            = "${azurerm_resource_group.main.location}"
  resource_group_name = "${azurerm_resource_group.main.name}"

  ip_configuration {
    name                          = "${var.vm_sql_name}-ipconf"
    subnet_id                     = "${azurerm_subnet.subnetsql.id}"
    private_ip_address_allocation = "Dynamic"
   }
}
resource "azurerm_virtual_machine" "vm_sql" {
  name                  = "${var.vm_sql_name}-vm"
  location              = "${azurerm_resource_group.main.location}"
  resource_group_name   = "${azurerm_resource_group.main.name}"
  network_interface_ids = ["${azurerm_network_interface.vm_sql.id}"]
  vm_size               = "${var.vm_standardsql_size}"

  # Uncomment this line to delete the OS disk automatically when deleting the VM
  delete_os_disk_on_termination = true


  # Uncomment this line to delete the data disks automatically when deleting the VM
  delete_data_disks_on_termination = true

  storage_image_reference {
    publisher = "${var.vm_standard_publisher}"
    offer     = "${var.vm_standard_offer}"
    sku       = "${var.vm_standard_sku}"
    version   = "${var.vm_standard_version}"
  }
  storage_os_disk {
    name              = "${var.vm_sql_name}-disk"
    caching           = "ReadWrite"
    create_option     = "FromImage"
    managed_disk_type = "${var.vm_standard_disktype}"
  }
  storage_data_disk {
    name = "${var.vm_sql_name}-datadisk"
    create_option = "Empty"
    disk_size_gb = "256"
    lun = "2"
    managed_disk_type = "${var.vm_standard_disktype}"
  }
  os_profile {
    computer_name  = "${var.vm_sql_name}"
    admin_username = "labadmin"
    admin_password = "Welcome2019!"
  }
  os_profile_windows_config{
  }
}
#######-\

#######-AD Virtual Machine Configuration
resource "azurerm_public_ip" "pip_ad" {
  name                = "${var.vm_ad_name}-pip"
  location            = "${azurerm_resource_group.main.location}"
  resource_group_name = "${azurerm_resource_group.main.name}"
  allocation_method   = "Dynamic"
  domain_name_label   = "${var.participant}${var.vm_ad_name}"
}
resource "azurerm_network_interface" "vm_ad" {
  name                = "${var.vm_ad_name}-nic"
  location            = "${azurerm_resource_group.main.location}"
  resource_group_name = "${azurerm_resource_group.main.name}"

  ip_configuration {
    name                          = "${var.vm_ad_name}-ipconf"
    subnet_id                     = "${azurerm_subnet.subnetad.id}"
    private_ip_address_allocation = "Dynamic"
    public_ip_address_id          = "${azurerm_public_ip.pip_ad.id}"
  }
}
resource "azurerm_virtual_machine" "vm_ad" {
  name                  = "${var.vm_ad_name}-vm"
  location              = "${azurerm_resource_group.main.location}"
  resource_group_name   = "${azurerm_resource_group.main.name}"
  network_interface_ids = ["${azurerm_network_interface.vm_ad.id}"]
  vm_size               = "${var.vm_standardvm_size}"

  # Uncomment this line to delete the OS disk automatically when deleting the VM
  delete_os_disk_on_termination = true


  # Uncomment this line to delete the data disks automatically when deleting the VM
  delete_data_disks_on_termination = true

  storage_image_reference {
    publisher = "${var.vm_standard_publisher}"
    offer     = "${var.vm_standard_offer}"
    sku       = "${var.vm_standard_sku}"
    version   = "${var.vm_standard_version}"
  }
  storage_os_disk {
    name              = "${var.vm_ad_name}-disk"
    caching           = "ReadWrite"
    create_option     = "FromImage"
    managed_disk_type = "${var.vm_standard_disktype}"
  }
  storage_data_disk {
    name = "${var.vm_ad_name}-datadisk"
    create_option = "Empty"
    disk_size_gb = "128"
    lun = "2"
    managed_disk_type = "${var.vm_standard_disktype}"
  }
  os_profile {
    computer_name  = "${var.vm_ad_name}"
    admin_username = "labadmin"
    admin_password = "Welcome2019!"
  }
  os_profile_windows_config{
  }
}
#######-\