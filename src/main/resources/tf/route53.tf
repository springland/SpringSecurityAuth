data "aws_route53_zone" "primary" {
  name         = "inkuii.com"
  private_zone = false
}

resource "aws_route53_record" "app-server-record" {
  zone_id = data.aws_route53_zone.primary.zone_id
  name    = "${var.domain}"
  type    = "A"
  ttl     = "300"
  records = [aws_instance.certinstance.public_ip]
}