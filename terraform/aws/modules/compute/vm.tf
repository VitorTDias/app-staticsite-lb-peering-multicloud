//vm publica

resource "aws_security_group" "sg_public" {
    name   = "sg_public"
    vpc_id = "${var.rede_pub_id}"
    
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
        cidr_blocks = ["${var.rede_pub_cidr}"]
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

data "template_file" "cloud_init" {
    template = "${file("./modules/compute/init/cloud_init.sh")}"
}

resource "aws_instance" "ec2_public1a" {
    ami                    = "${var.ami}"
    instance_type          = "t2.micro"
    subnet_id              = "${var.subnet_pub_id}"
    vpc_security_group_ids = [aws_security_group.sg_public.id]
    user_data              = "${base64encode(data.template_file.cloud_init.rendered)}"
    key_name               = "vockey"
}

resource "aws_instance" "ec2_public1b" {
    ami                    = "${var.ami}"
    instance_type          = "t2.micro"
    subnet_id              = "${var.subnet_pub_id}"
    vpc_security_group_ids = [aws_security_group.sg_public.id]
    user_data              = "${base64encode(data.template_file.cloud_init.rendered)}"
    key_name               = "vockey"
}

//vm privada

resource "aws_security_group" "sg_private" {
    name   = "sg_private"
    vpc_id = "${var.rede_pri_id}"
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
        cidr_blocks = ["${var.rede_pri_cidr}"]
    }
}

resource "aws_instance" "ec2_private2a" {
    ami                    = "${var.ami}"
    instance_type          = "t2.micro"
    subnet_id              = "${var.subnet_pri_id}"
    vpc_security_group_ids = [aws_security_group.sg_private.id]
    user_data              = "${base64encode(data.template_file.cloud_init.rendered)}"
    key_name               = "vockey"
}

resource "aws_elb" "elb" {
    name            = "staticsite-lb-aws-vitor"
    security_groups = [aws_security_group.sg_public.id]
    subnets         = ["${var.subnet_pub_id}", "${var.subnet_pri_id}"]
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