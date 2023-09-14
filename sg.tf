resource "aws_security_group" "server_sg" {
  name = "sec-${local.service}-${local.env}"

  vpc_id = "vpc-0b16b53b9d0cb44e8"
  tags = {
    department = local.department
    env        = local.env
    entity     = local.entity
    purpose    = local.purpose
    Name       = "sec-${local.service}-${local.env}"
  }
}


resource "aws_security_group_rule" "ingress-80" {
  type              = "ingress"
  from_port         = 80
  to_port           = 80
  protocol          = "tcp"
  cidr_blocks       = ["0.0.0.0/0"]
  security_group_id = aws_security_group.server_sg.id
  description       = "http"
}

resource "aws_security_group_rule" "ingress-443" {
  type              = "ingress"
  from_port         = 443
  to_port           = 443
  protocol          = "tcp"
  cidr_blocks       = ["0.0.0.0/0"]
  security_group_id = aws_security_group.server_sg.id
  description       = "https"
}




resource "aws_security_group_rule" "egress_all" {
  type              = "egress"
  from_port         = 0
  to_port           = 0
  protocol          = "-1"
  cidr_blocks       = ["0.0.0.0/0"]
  security_group_id = aws_security_group.server_sg.id
  description       = "egress"
}
