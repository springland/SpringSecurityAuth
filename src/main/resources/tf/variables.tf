variable "domain" {
  type = string
  description = " domain name"
  default = "dev.inkuii.com"
}

variable "myip" {
  type = string
  description = "my ip address to ssh to the host"
  default = "38.81.106.160"
}

variable "s3_bucket_name" {
  type = string
  description = "s3 bucket to store certification"
  default = "springland-certs-bucket"
}

variable "key_name"{
  type = string
  description = "ec2 instance key name"
  default ="minecraft"
}

locals {
  my_ip_cidr = "${var.myip}/32"
}