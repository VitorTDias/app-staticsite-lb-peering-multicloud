module "rede" {
    source      = "./modules/rede"
    rede_pub_cidr   = "${var.rede_pub_cidr}"
    subnet_pub_cidr = "${var.subnet_pub_cidr}"
    rede_pri_cidr   = "${var.rede_pri_cidr}"
    subnet_pri_cidr = "${var.subnet_pri_cidr}"
   
}

module "compute" {
    source     = "./modules/compute"
    rede10_id    = "${module.rede.vpc10_id}"
    rede20_id    = "${module.rede.vpc20_id}"
    subnet_pub_cidr  = "${module.rede.subnet_pub_id}"
    subnet_pri_cidr  = "${module.rede.subnet_pri_id}"
    rede_pub_cidr  = "${var.rede_pub_cidr}"
    rede_pri_cidr  = "${var.rede_pri_cidr}"
    ami        = "${var.ami}"
    depends_on = [modules.rede]
}