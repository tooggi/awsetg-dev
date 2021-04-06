//data "aws_ami" "amazon_linux_2" {
//  owners      = ["amazon"]
//  most_recent = true
//
//  filter {
//    name   = "name"
//    values = ["amzn2-ami-hvm*"]
//  }
//
//  filter {
//    name   = "root-device-type"
//    values = ["ebs"]
//  }
//
//  filter {
//    name   = "virtualization-type"
//    values = ["hvm"]
//  }
//}
//
//resource "aws_instance" "jenkins" {
//  ami = data.aws_ami.amazon_linux_2.id
//  instance_type = "t2.micro"
//
//  subnet_id = aws_subnet.public_subnets[0].id
//
//  tags = {
//    Name = "${var.prefix}-EC2"
//  }
//}