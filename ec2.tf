data "aws_ami" "amazon_linux_2" {
  owners      = ["amazon"]
  most_recent = true

  filter {
    name   = "name"
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

resource "aws_security_group" "allow_web_ssh" {
  name = "allow_web_ssh"
  description = "Allow Web and SSH traffic"
  vpc_id = aws_vpc.main_vpc.id

  dynamic "ingress" {
    for_each = ["22", "80", "443"]
    content {
      from_port = ingress.value
      to_port = ingress.value
      protocol = "tcp"
      cidr_blocks = ["0.0.0.0/0"]
    }
  }

  ingress {
    from_port = -1
    protocol = "icmp"
    to_port = -1
    cidr_blocks = ["0.0.0.0/0"]
  }

  egress {
    from_port = 0
    protocol = "-1"
    to_port = 0
    cidr_blocks = ["0.0.0.0/0"]
  }

  tags = {
    Name = "${var.prefix}-SG"
  }
}

resource "aws_instance" "jenkins" {
  ami = data.aws_ami.amazon_linux_2.id
  instance_type = "t2.micro"

  subnet_id = aws_subnet.public_subnets[0].id
  vpc_security_group_ids = [aws_security_group.allow_web_ssh.id]

  tags = {
    Name = "${var.prefix}-EC2"
  }
}