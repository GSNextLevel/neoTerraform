provider "aws" {
    region = "ap-northeast-2"
}

resource "aws_security_group" "instance" {
    name = "WebServer-SG-Terraform"

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

    tags = {
        Name    = "WebServer SG by Terraform"
        Owner   = "Heuristic Wave" 
    }
}

resource "aws_instance" "example" {
    ami = "ami-08c64544f5cfcddd0"
    instance_type = "t2.micro"
    vpc_security_group_ids = [aws_security_group.instance.id]

    user_data = <<EOF
                #!/bin/sh
                yum -y update
                yum -y install httpd
                MYIP=`curl http://169.254.169.254/latest/meta-data/local-ipv4`
                echo "<h2>Webserver with PrivateIP: $MYIP</h2><br>Built by Terraform" > /var/www/html/index.html
                service httpd start
                chkconfig httpd on
                EOF

    tags = {
        Name    = "WebServer Built by Terraform"
        Owner   = "Heuristic Wave" 
    }
}

output "instance_public_ip" {
  description = "Public IP address of the EC2 instance"
  value       = [aws_instance.example.public_ip]
}