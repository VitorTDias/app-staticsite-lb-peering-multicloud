module "rg" {
    source   = "./modules/rg"
    rg_name  = "${var.rg_name}"
    location = "${var.location}"
}

module "rede" {
    source      = "./modules/rede"
    rg_name     = "${var.rg_name}"
    location    = "${var.location}"
    vnet10_cidr   = "${var.vnet10_cidr}"
    subnet_vnet10a_cidr = "${var.subnet_vnet10a_cidr}"
    subnet_vnet10b_cidr = "${var.subnet_vnet10b_cidr}"
    vnet20_cidr   = "${var.vnet20_cidr}"
    subnet_vnet20_cidr = "${var.subnet_vnet20_cidr}"    
    depends_on  = [module.rg]
}
#
module "compute" {
    source     = "./modules/compute"
    rg_name    = "${var.rg_name}"
    location   = "${var.location}"
    fqdn       = "${var.fqdn}"
    subnet_vnet10a_id  = "${module.rede.subnet_vnet10a_id}"
    subnet_vnet10b_id  = "${module.rede.subnet_vnet10b_id}"
    subnet_vnet20_id  = "${module.rede.subnet_vnet20_id}"
    depends_on = [module.rede]
}