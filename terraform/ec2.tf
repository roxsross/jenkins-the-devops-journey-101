resource "aws_instance" "server" {
    ami = "${var.ami}"
    instance_type = "${var.instance_type}"
    vpc_security_group_ids = [ aws_security_group.grupo_seguridad.id ]
    key_name = "${var.key}"
    tags = {
      "Name" = "${var.app}-ec2-${var.env}"
      "Infra" = "Terraform"
      "Owner" = "DevOps Team"
    }
    user_data = <<EOF
#! /bin/bash
sudo amazon-linux-extras install -y nginx1
sudo service nginx start
sudo rm /usr/share/nginx/html/index.html
echo '<html><head><title>Bootcamp Terraform Server</title></head><body style="background-color: #1F778D;"><p style="text-align: center;"><span style="color:#FFFFFF;"><span style="font-size:28px;">Welcome to Bootcamp Class Terraform </span></span></p></body></html>' | sudo tee /usr/share/nginx/html/index.html
EOF
}