provider "aws" {
    region = "ap-northeast-2"
}

resource "aws_security_group" "instance" {
    name = "WebCluster-SG-Terraform"

    ingress {
        from_port   = 80
        to_port     = 80
        protocol    = "tcp"
        cidr_blocks = ["0.0.0.0/0"]
    }

    egress {
        from_port   = 0
        to_port     = 0
        protocol    = "-1"
        cidr_blocks = ["0.0.0.0/0"]
    }

    lifecycle {
        create_before_destroy = true
    }

    tags = {
        Name    = "WebCluster SG by Terraform"
        Owner   = "Heuristic Wave" 
    }
}

resource "aws_launch_configuration" "example" {
    image_id        = "ami-08c64544f5cfcddd0"
    instance_type   = "t2.micro"
    security_groups = [aws_security_group.instance.id]

    user_data = <<EOF
#!/bin/sh
yum -y install httpd php mysql php-mysql
chkconfig httpd on
systemctl start httpd
if [ ! -f /var/www/html/immersion-day-app.tar.gz ]; then
   cd /var/www/html
   wget https://kr-id-general.workshop.aws/sh/immersion-day-app.tar.gz
   tar xvfz immersion-day-app.tar.gz
   chown apache:root /var/www/html/rds.conf.php
fi
yum -y update
EOF

    lifecycle {
        create_before_destroy = true
    }
}

data "aws_availability_zones" "all" {}

resource "aws_autoscaling_group" "exmaple" {
    launch_configuration    = aws_launch_configuration.example.id
    availability_zones      = data.aws_availability_zones.all.names

    load_balancers          = [aws_elb.example.name]
    health_check_type       = "ELB"

    min_size = 2
    max_size = 10

    tag {
        key                 = "Name"
        value               = "terraform-asg-exmaple"
        propagate_at_launch = true
    }
}

// clasic elb
resource "aws_elb" "example" {
    name                = "terraform-asg-example"
    availability_zones  = data.aws_availability_zones.all.names
    security_groups     = [aws_security_group.elb.id]

    listener {
        lb_port             = 80
        lb_protocol         = "http"
        instance_port       = 80
        instance_protocol   = "http"
    }

    health_check {
        healthy_threshold   = 2
        unhealthy_threshold = 2
        timeout             = 3
        interval            = 30
        target = "HTTP:80/"
    }
}

resource "aws_security_group" "elb" {
    name = "terraform-example-elb"

    ingress {
        from_port   = 80
        to_port     = 80
        protocol    = "tcp"
        cidr_blocks = ["0.0.0.0/0"]
    }

    egress {
        from_port   = 0
        to_port     = 0
        protocol    = "-1"
        cidr_blocks = ["0.0.0.0/0"]
    }
}

output "elb_dns_name" {
    value = aws_elb.example.dns_name
}
