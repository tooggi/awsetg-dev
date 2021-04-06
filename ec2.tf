data "aws_ami" "aws_linux_2" {
  owners = ["amazon"]
  most_recent = true

  filter {
    name = "name"
    values = []
  }

  filter {
    name = "name"
    values = ["amzn2-ami-hvm*"]
  }

  filter {
    name   = "root-device-type"
    values = ["ebs"]
  }

  filter {
    name   = "virtualization-type"
    values = ["hvm"]
  }
}

output "amazon_ami" {
  value = data.aws_ami.aws_linux_2.name
}