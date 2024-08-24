resource "aws_security_group" "jenkins_security_group" {
  name = "Jenkins-SG"
  description = "Security Group for Jenkins Server"
  ingress {
    from_port = 80
    to_port = 80
    protocol = "tcp"
    cidr_blocks = local.public_ip_cidr
  }

  ingress {
    from_port = 443
    to_port = 443
    protocol = "tcp"
    cidr_blocks = local.public_ip_cidr
  }

  ingress {
    from_port = 22
    to_port = 22
    protocol = "tcp"
    cidr_blocks = ["${chomp(data.http.myip.response_body)}/32", "18.60.252.248/29"]
  }

  egress {
    from_port = 0
    to_port = 0
    protocol = "-1"
    cidr_blocks = local.public_ip_cidr
  }
  
  tags = merge({
    "Name" = "Jenkins SG"
  },local.common_tags)
}

resource "aws_instance" "jenkins_server" {
  ami = data.aws_ami.amazon_linux_3.id
  vpc_security_group_ids = [aws_security_group.jenkins_security_group.id]
  instance_type = var.ec2_instance_type
  tags = merge({
    "Description" = "Jenkins Server"
    "Name" = "Jenkins Server"
  },local.common_tags)
}