provider "aws" {
}

data "aws_caller_identity" "current" {}

data "aws_route53_zone" "public" {
  name = var.domain_name
  private_zone = false
}

resource "aws_route53_record" "jenkins" {
  name = "jenkins.${data.aws_route53_zone.public.name}"
  type = "A"
  zone_id = data.aws_route53_zone.public.id
  ttl = "300"
  records = [aws_instance.jenkins.public_ip]
}