#Ec2 instance //---------------------------------------

data "terraform_remote_state" "network" {
  backend = "atlas"

  config {
    name = "${var.org}/${var.workspace_name}"
  }
}

provider "aws" {
  region = "${var.aws_region}"
}

resource "aws_instance" "ec2_vm" {
  count = "${var.count}"
  ami           = "${var.ami}"
  instance_type = "${var.instance_type}"
  
# VPC Subnet
subnet_id = "${aws_subnet.subnet-public-1a.id}"

# Security Group
vpc_security_group_ids = ["${aws_security_group.secgroup.id}"]

# SSH key in AWS account
key_name = "${var.ssh_key}"
 
# tags
tags {
  Name = "ec2-${count.index}-${var.environment_name}"
  owner = "${var.owner}"
  TTL = "${var.ttl}"
 }
}
