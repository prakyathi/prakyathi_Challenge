resource "aws_instance" "app_server" {
  ami                    = data.aws_ami.ubuntu.image_id
  instance_type          = "t3.small"
  iam_instance_profile   = aws_iam_instance_profile.iam_profile.id
  key_name               = "app-key-pair"
  subnet_id              = "subnet-05da6d659d413d8a5"
  vpc_security_group_ids = [aws_security_group.server_sg.id]

  root_block_device {
    volume_type = "gp3"
    volume_size = "8"
  }

  tags = {
    Department = local.department
    Env        = local.env
    Entity     = local.entity
    Name       = "${local.region}-ec-${local.service}-${local.env}"
  }

  user_data  = data.template_file.startup_app.rendered
  depends_on = [aws_security_group.server_sg, aws_iam_instance_profile.iam_profile, aws_key_pair.app-key-pair]
}

# key-pair
resource "aws_key_pair" "app-key-pair" {
  key_name   = "app-key-pair"
  public_key = tls_private_key.rsa.public_key_openssh
}
resource "tls_private_key" "rsa" {
  algorithm = "RSA"
  rsa_bits  = 4096
}
resource "local_file" "app-key" {
  content  = tls_private_key.rsa.private_key_pem
  filename = "app-key-pair"
}
