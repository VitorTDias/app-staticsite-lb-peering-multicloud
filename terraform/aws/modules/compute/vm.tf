//security groups

resource "aws_security_group" "sg_elb" {
  name        = "sg_elb"
  description = "sg_elb"
  vpc_id      = "${var.vpc10_id}"
  egress {
    from_port   = 0
    to_port     = 0
    protocol    = -1
    cidr_blocks = ["0.0.0.0/0"]
  }
  ingress {
    from_port   = 80
    to_port     = 80
    protocol    = "tcp"
    cidr_blocks = ["0.0.0.0/0"]
  }
  tags = {
    Name = "sg_elb"
  }
}

resource "aws_security_group" "sg_public" {
    name   = "sg_public"
    vpc_id = "${var.vpc10_id}"
    
    egress {
        from_port   = 0
        to_port     = 0
        protocol    = "-1"
        cidr_blocks = ["0.0.0.0/0"]
    }

    ingress {
        from_port   = 0
        to_port     = 0
        protocol    = "-1"
        cidr_blocks = ["${var.vpc10_cidr}", "${var.vpc20_cidr}"]
    }

    ingress {
        from_port   = 22
        to_port     = 22
        protocol    = "tcp"
        cidr_blocks = ["0.0.0.0/0"]
    }
    
    ingress {
        from_port   = 80
        to_port     = 80
        protocol    = "tcp"
        cidr_blocks = ["0.0.0.0/0"]
    }

}

resource "aws_security_group" "sg_private" {
    name   = "sg_private"
    vpc_id = "${var.vpc20_id}"
    egress {
        from_port   = 0
        to_port     = 0
        protocol    = "-1"
        cidr_blocks = ["0.0.0.0/0"]
    }
    ingress {
        from_port   = 0
        to_port     = 0
        protocol    = "-1"
        cidr_blocks = ["${var.vpc20_cidr}", "${var.vpc10_cidr}"]
    }
}

//////VMS PUBLICA

resource "aws_instance" "ec2_public1a" {
    ami                    = "${var.ami}"
    instance_type          = "t2.micro"
    subnet_id              = "${var.sn_vpc10_puba_id}"
    vpc_security_group_ids = [aws_security_group.sg_public.id]
    user_data              = "${base64encode(data.template_file.cloud_init.rendered)}"
    key_name               = "vockey"
}

resource "aws_instance" "ec2_public1b" {
    ami                    = "${var.ami}"
    instance_type          = "t2.micro"
    subnet_id              = "${var.sn_vpc10_pubb_id}"
    vpc_security_group_ids = [aws_security_group.sg_public.id]
    user_data              = "${base64encode(data.template_file.cloud_init.rendered)}"
    key_name               = "vockey"
}

//vm privada



resource "aws_instance" "ec2_private2a" {
    ami                    = "${var.ami}"
    instance_type          = "t2.micro"
    subnet_id              = "${var.sn_vpc20_pri_id}"
    vpc_security_group_ids = [aws_security_group.sg_private.id]
    user_data              = "${base64encode(data.template_file.cloud_init.rendered)}"
    key_name               = "vockey"
}

////// Load balacer

resource "aws_elb" "elb" {
    name            = "staticsite-lb-aws-vitor"
    security_groups = [aws_security_group.sg_public.id]
    subnets         = ["${var.sn_vpc10_puba_id}", "${var.sn_vpc10_puba_id}"]
    listener {
        instance_port     = 80
        instance_protocol = "http"
        lb_port           = 80
        lb_protocol       = "http"
    }
    health_check {
        healthy_threshold   = 2
        unhealthy_threshold = 2
        timeout             = 3
        target              = "HTTP:80/"
        interval            = 30
    }
    instances = [
        aws_instance.ec2_public1a.id, 
        aws_instance.ec2_public1b.id,
    ]
}


output "elb_dns_name" {
    value = aws_elb.elb.dns_name
}

data "template_file" "cloud_init" {
    template = "${file("./modules/compute/init/cloud_init.sh")}"
}