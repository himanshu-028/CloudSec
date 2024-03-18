resource "aws_iam_role" "iam_role" {
  name               = "IAM-role"
  assume_role_policy = data.aws_iam_policy_document.policy_document.json
}
 
resource "aws_iam_policy" "iam_policy" {
  name        = "IAM-Policy"
  description = "IAM policy for EC2 instance"
  policy      = jsonencode({
    Version = "2012-10-17"
    Statement = [
      {
        Effect    = "Allow"
        Action    = [
          "ec2:RunInstances",
          "ec2:DescribeInstances"
        ]
        Resource  = "*"
      }
    ]
  })
}
 
data "aws_iam_policy_document" "policy_document" {
  statement {
    actions = ["sts:AssumeRole"]
 
    principals {
      type        = "Service"
      identifiers = ["ec2.amazonaws.com"]
    }
  }
}
 
resource "aws_iam_role_policy_attachment" "role_attachment" {
  role       = aws_iam_role.iam_role.name
  policy_arn = aws_iam_policy.iam_policy.arn
}
 
resource "aws_instance" "instance" {
  ami           = var.ec2_ami
  instance_type = var.ec2_instance_type
}
 
resource "null_resource" "detach_policy" {
  depends_on = [aws_instance.instance]
  provisioner "local-exec" {
    command = "aws iam detach-role-policy --role-name ${aws_iam_role.iam_role.name} --policy-arn ${aws_iam_policy.iam_policy.arn}"
  }
}
 
resource "null_resource" "remove_role" {
  depends_on = [null_resource.detach_policy]
  provisioner "local-exec" {
    command = "aws iam delete-role --role-name ${aws_iam_role.iam_role.name}"
  }
}
