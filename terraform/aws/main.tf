module "rede" {
    source      = "./modules/rede"
    rede_cidr   = "${var.rede_pub_cidr}"
    subnet_cidr = "${var.subnet_pub_cidr}"
    rede_cidr   = "${var.rede_pri_cidr}"
    subnet_cidr = "${var.subnet_pri_cidr}"
   
}

module "compute" {
    source     = "./modules/compute"
    rede_id    = "${module.rede.vpc10_id}"
    rede_id    = "${module.rede.vpc20_id}"
    subnet_id  = "${module.rede.subnet_pub_id}"
    subnet_id  = "${module.rede.subnet_pri_id}"
    rede_cidr  = "${var.rede_pub_cidr}"
    rede_cidr  = "${var.rede_pri_cidr}"
    ami        = "${var.ami}"
    depends_on = [module.rede]
}