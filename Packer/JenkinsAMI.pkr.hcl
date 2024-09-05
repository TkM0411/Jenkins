packer {
  required_plugins {
    amazon = {
      source  = "github.com/hashicorp/amazon"
      version = "~> 1"
    }
  }
}

variable "aws_access_key" {
  type    = string
  default = "${env("PKR_VAR_aws_access_key")}"
}

variable "aws_secret_key" {
  type    = string
  default = "${env("PKR_VAR_aws_secret_key")}"
}

locals {
  timestamp = regex_replace(timestamp(), "[- TZ:]", "")
  dynamic_tags = {
    "Created On Date" = formatdate("DD-MMM-YYYY", timeadd(timestamp(), "5h30m"))
  }
}

variable "aws_region" {
  type    = string
  default = "ap-south-2"
}

source "amazon-ebs" "ubuntu-base-ami" {
  ami_name      = "jenkins-packer-${local.timestamp}"
  instance_type = "t3.micro"
  region        = var.aws_region
  source_ami_filter {
    filters = {
      name                = "ubuntu/images/*ubuntu-noble-24.04-amd64-server-*"
      root-device-type    = "ebs"
      virtualization-type = "hvm"
    }
    most_recent = true
    owners      = ["099720109477"]
  }
  encrypt_boot = true
  ssh_username = "ubuntu"
  tags = merge({
    Name      = "Jenkins AMI"
    CreatedBy = "TkM Packer"
  }, local.dynamic_tags)
}

build {
  sources = [
    "source.amazon-ebs.ubuntu-base-ami"
  ]

  provisioner "shell" {
    script = "JenkinsInstall.sh"
  }
}