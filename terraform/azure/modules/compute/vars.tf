variable "rg_name" {
    type    = string
    default = "rg-default"
}

variable "location" {
    type    = string
    default = "brazilsouth"
}

variable "username" {
    type    = string
    default = "azureadmin"
}

variable "fqdn" {
    type    = string
    default = "fqdn-default"
}

variable subnet_vnet10a_id{}

variable subnet_vnet10b_id{}

variable subnet_vnet20_id{}