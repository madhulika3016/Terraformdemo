terraform {
  required_providers {
    aws = {
      source  = "hashicorp/aws"
      version = "5.9.0"
    }
  }
}




variable "awsprops" {
    type = map(string)
    default = {
    region = "us-east-1"
    ami = "ami-05548f9cecf47b442"
    itype = "t2.micro"
    publicip = true
    keyname = "mykey"
  }
}

provider "aws" {
  region = lookup(var.awsprops, "region")
}

resource "aws_instance" "project-iac" {
  ami = lookup(var.awsprops, "ami")
  instance_type = lookup(var.awsprops, "itype")
  associate_public_ip_address = lookup(var.awsprops, "publicip")
  key_name = lookup(var.awsprops, "keyname")
  
  root_block_device {
    delete_on_termination = true
    iops = 150
    volume_size = 50
    volume_type = "gp3"
  }
  tags = {
    Name ="SERVER01"
    Environment = "DEV"
    OS = "UBUNTU"
    Managed = "IAC"
  }
}


output "ec2instance" {
  value = aws_instance.project-iac.public_ip
}
