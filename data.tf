data "http" "myip" {
  url = "https://ipv4.icanhazip.com"
}

data "aws_ssm_parameter" "jenkins_ami" {
  name = "/ami/Ubuntu/Jenkins"
}