resource "aws_iam_instance_profile" "iam_profile" {
  name = "iam-${local.service}-${local.env}-profile"
  role = aws_iam_role.role.name
}

resource "aws_iam_role" "role" {
  name = "iam-${local.service}_${local.env}-role"

  assume_role_policy = jsonencode({
    Version : "2012-10-17",
    Statement : [
      {
        Sid : "",
        Effect : "Allow",
        Action : "sts:AssumeRole",
        Principal : { "Service" : "ec2.amazonaws.com" }
      }
    ]
  })
}




resource "aws_iam_role_policy_attachment" "role-policy-attach" {
  count      = length(var.managed_policies)
  policy_arn = element(var.managed_policies, count.index)
  role       = aws_iam_role.role.name
}
