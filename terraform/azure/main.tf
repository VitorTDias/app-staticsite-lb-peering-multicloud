module "rg" {
    source   = "./modules/rg"
    rg_name  = "${var.rg_name}"
    location = "${var.location}"
}

module "rede" {
    source      = "./modules/rede"
    rg_name     = "${var.rg_name}"
    location    = "${var.location}"
    vnet_cidr   = "${var.vnet_cidr}"
    subnet_cidr = "${var.subnet_cidr}"
    depends_on  = [module.rg]
}

module "compute" {
    source     = "./modules/compute"
    rg_name    = "${var.rg_name}"
    location   = "${var.location}"
    fqdn       = "${var.fqdn}"
    subnet_id  = "${module.rede.subnet_id}"
    depends_on = [module.rede]
}