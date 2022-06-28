provider "azurerm" {
  # tenant_id       = "${var.tenant_id}"
  # subscription_id = "${var.subscription_id}"
  # client_id       = "${var.client_id}"
  # client_secret   = "${var.client_secret}"
  features {}
}
terraform {
  backend "azurerm" {
    storage_account_name = "terraformstoragedatmq"
    container_name       = "terraform"
    key                  = "file"
    access_key           = "${var.access_key}"
  }
}
module "resource_group" {
  source         = "./modules/resource_group"
  resource_group = var.resource_group
  location       = var.location
}
# Reference the AppService Module here.

module "appservice" {
  source                = "./modules/appservice"
  resource_group        = module.resource_group.resource_group_name
  location              = var.location
  app_service_plan_name = "datmq-testappservice"
  app_service_name      = "datmq-testappservice"
  tags                  = {
    tier = var.tier
    deployment = var.deployment
  }
}
