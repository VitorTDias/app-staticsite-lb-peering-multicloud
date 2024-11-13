output "vpc10_id" {
    value = "${aws_vpc.vpc10.id}"
}

output "sn_vpc10_puba_id" {
    value = "${aws_subnet.sn_vpc10_puba.id}"
}

output "sn_vpc10_pubb_id" {
    value = "${aws_subnet.sn_vpc10_pubb.id}"
}

output "vpc20_id" {
    value = "${aws_vpc.vpc20.id}"
}

output "sn_vpc20_pri_id" {
    value = "${aws_subnet.sn_vpc20_pri.id}"
}
