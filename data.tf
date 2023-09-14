# vpc and subnets

data "aws_caller_identity" "current" {}



data "template_file" "startup_app" {
  template = file("web-app.sh")
   vars = {
    DOMAIN          = "demo.mlopshub.com"
  }
}




data "aws_ami" "ubuntu" {

  filter {
    name   = "name"
    values = ["ubuntu/images/hvm-ssd/ubuntu-jammy-22.04-amd64-server-20230516"]
  }
  filter {
    name   = "virtualization-type"
    values = ["hvm"]
  }

  owners = ["099720109477"]
}
