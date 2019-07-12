########-Provider Variables
variable "provider_subscription_id" {
  description = "Subscription ID"
}
variable "provider_client_id" {
  description = "Application ID"
}
variable "provider_client_secret" {
  description = "Application Token"
}
variable "provider_tenant_id" {
  description = "Azure Active Directory ID"
}
########-\

variable "location" {
  description = "Location"
  default = "northeurope"
}
variable "participant" {
  description = "Name of the Lab participant"
}
#######-RG and Network Variables
variable "rg_name" {
  default = "labserver"
}
variable "vn_cidr" {
  default = "192.168.0.0/16"
}
variable "rdpgwsource1" {
  description = "SourceIP for NSG"
}
#Subnet WFE
variable "subnetwfe_name" {
  default = "wfe"
}
variable "subnetwfe_cidr" {
  default = "192.168.0.0/27"
}
variable "subnetwfe_gateway_ip" {
  default = "192.168.0.1"
}

#Subnet SQL
variable "subnetsql_name" {
  default = "sql"
}
variable "subnetsql_cidr" {
  default = "192.168.0.160/27"
}
variable "subnetsql_gateway_ip" {
  default = "192.168.0.161"
}
#Subnet AD
variable "subnetad_name" {
  default = "ad"
}
variable "subnetad_cidr" {
  default = "192.168.0.192/27"
}
variable "subnetad_gateway_ip" {
  default = "192.168.0.193"
}
#######-\

#######-VM Variables

#Standard Size of Servers
variable "vm_standardvm_size" {
  default = "Standard_A2_v2"
}
#Standard Size of SQL Servers
variable "vm_standardsql_size" {
  default = "Standard_A2m_v2"
}
#Standard OS Image of all Servers
variable "vm_standard_publisher" {
  default = "MicrosoftWindowsServer"
}
variable "vm_standard_offer" {
  default = "WindowsServer"
}
variable "vm_standard_sku" {
  default = "2019-Datacenter"
}
variable "vm_standard_version" {
  default = "2019.0.20190314"
}
variable "vm_standard_disktype" {
  default = "StandardSSD_LRS"
}

#######-\

#######-VM WFE Specifications
variable "vm_wfe_name" {
  default = "labserverwfe1"
}
#######-\

#######-VM SQL Specifications
variable "vm_sql_name" {
  default = "labserversql1"
}
#######-\

#######-VM AD Specifications
variable "vm_ad_name" {
  default = "labserverad1"
}
#######-\