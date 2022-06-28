# Resource Group/Location
variable "app_service_plan_name" {}
variable "app_service_name" {}
variable "location" {}
variable "resource_group" {}

# Tags
variable "tags" {
  type = map
}