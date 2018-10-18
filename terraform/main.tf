# Variables' set

variable "access_key" {}
variable "secret_key" {}
variable "region" {}
variable "ip_ssh_range" {
  type = "list"
}

variable "instance_name" {
  default = "web-idwall"
}

data "template_file" "docker_install" {
  template = "${file("./install-docker.sh")}"
}

# ----------------------------------------


# AWS connection provider
provider "aws" {
  access_key = "${var.access_key}"
  secret_key = "${var.secret_key}"
  region     = "${var.region}"
}

# Canonical Ubuntu 18.04 latest AMI
data "aws_ami" "ubuntu" {
  most_recent = true

  filter {
    name   = "name"
    values = ["ubuntu/images/hvm-ssd/ubuntu-bionic-18.04-amd64-server-*"]
  }

  filter {
    name   = "virtualization-type"
    values = ["hvm"]
  }

  owners = ["099720109477"] # Canonical
}

# Docker-Web (Apache) instance
resource "aws_instance" "docker-web" {
  ami           = "${data.aws_ami.ubuntu.id}"
  instance_type = "t2.micro"
  associate_public_ip_address = "true"
  
  user_data = "${data.template_file.docker_install.rendered}"

  tags {
    Name = "${var.instance_name}"
  }
}

# Security group
resource "aws_security_group" "docker-web" {
  description = "Used in ${var.instance_name}"
}

resource "aws_network_interface_sg_attachment" "sg_attachment" {
  security_group_id    = "${aws_security_group.docker-web.id}"
  network_interface_id = "${aws_instance.docker-web.primary_network_interface_id}"
}

# Security group rules
resource "aws_security_group_rule" "ssh" {
  type              = "ingress"
  from_port         = 22
  to_port           = 22
  protocol          = "TCP"
  cidr_blocks       = ["${var.ip_ssh_range}"]
  security_group_id = "${aws_security_group.docker-web.id}"
}

resource "aws_security_group_rule" "http" {
  type              = "ingress"
  from_port         = 80
  to_port           = 80
  protocol          = "TCP"
  cidr_blocks       = ["0.0.0.0/0"]
  security_group_id = "${aws_security_group.docker-web.id}"
}

resource "aws_security_group_rule" "https" {
  type              = "ingress"
  from_port         = 443
  to_port           = 443
  protocol          = "TCP"
  cidr_blocks       = ["0.0.0.0/0"]
  security_group_id = "${aws_security_group.docker-web.id}"
}

resource "aws_security_group_rule" "instance_outbound_internet_access" {
  type              = "egress"
  from_port         = 0
  to_port           = 0
  protocol          = "-1"
  cidr_blocks       = ["0.0.0.0/0"]
  security_group_id = "${aws_security_group.docker-web.id}"
}

output "Docker Web - Public IP" {
  value = "${aws_instance.docker-web.public_ip}"
}
