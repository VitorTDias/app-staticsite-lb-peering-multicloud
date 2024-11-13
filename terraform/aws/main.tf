module "rede" {
    source      = "./modules/rede"
    vpc10_cidr   = "${var.vpc10_cidr}"
    subnet_puba_cidr = "${var.subnet_puba_cidr}"
    subnet_pubb_cidr = "${var.subnet_pubb_cidr}"    
    vpc20_cidr   = "${var.vpc20_cidr}"
    subnet_pri_cidr = "${var.subnet_pri_cidr}"
   
}

module "compute" {
    source     = "./modules/compute"
    vpc10_id    = "${module.rede.vpc10_id}"
    vpc20_id    = "${module.rede.vpc20_id}"
    sn_vpc10_puba_id  = "${module.rede.sn_vpc10_puba_id}"
    sn_vpc10_pubb_id  = "${module.rede.sn_vpc10_pubb_id}"
    sn_vpc20_pri_id  = "${module.rede.sn_vpc20_pri_id}"
    vpc10_cidr  = "${var.vpc10_cidr}"
    vpc20_cidr  = "${var.vpc20_cidr}"
    ami        = "${var.ami}"
    depends_on = [module.rede]
}