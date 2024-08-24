variable "aws_region" {
  type = string
  description = "AWS Region"
  default = "ap-south-2"
}

variable "ec2_instance_type" {
  type = string
  description = "EC2 Instance Type"
  default = "t3.micro"
}

variable "static_tags" {
  type = map(string)
  description = "Common Tags for all resources"
  default = {
    "Created By" = "Terraform"
    "Project" = "Jenkins Server Infrastructure"
    "Owner" = "TkM"
  }
}