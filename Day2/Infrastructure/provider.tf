provider "azurerm" {
# version = "~> 1.x"

subscription_id = "${var.provider_subscription_id}"
client_id       = "${var.provider_client_id}"
client_secret   = "${var.provider_client_secret}"
tenant_id       = "${var.provider_tenant_id}"
}
