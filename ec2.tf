resource "aws_security_group" "jenkins_security_group" {
  name = "Jenkins-SG"
  description = "Security Group for Jenkins Server"
  
  ingress {
    description = "Port 8080 for Jenkins"
    from_port = 8080
    to_port = 8080
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
  ami = data.aws_ssm_parameter.jenkins_ami.value
  vpc_security_group_ids = [aws_security_group.jenkins_security_group.id]
  instance_type = var.ec2_instance_type
  hibernation = true
  tags = merge({
    "Description" = "Jenkins Server"
    "Name" = "Jenkins Server"
  },local.common_tags)
}

resource "aws_eip" "jenkins_static_ip" {
  instance = aws_instance.jenkins_server.id
  domain   = "vpc"
  tags = merge({
    "Name" = "Jenkins Static IP"
    "Description" = "Static IP for Jenkins EC2"
  },local.common_tags)
}