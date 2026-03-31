data "aws_vpc" "selected" {
  filter {
    name   = "tag:Name"
    values = [var.vpc_name]
  }
}

data "aws_subnets" "private" {
  filter {
    name   = "vpc-id"
    values = [data.aws_vpc.selected.id]
  }
  filter {
    name   = "tag:Name"
    values = ["${var.vpc_name}-private-*"]
  }
}

data "aws_subnets" "public" {
  filter {
    name   = "vpc-id"
    values = [data.aws_vpc.selected.id]
  }
  filter {
    name   = "tag:Name"
    values = ["${var.vpc_name}-public-*"]
  }
}

data "aws_route53_zone" "nomad" {
  name = var.route53_zone_name
}

data "aws_ami" "selected" {
  most_recent = true
  owners      = [var.ec2_ami_owner]

  filter {
    name   = "name"
    values = [var.ec2_ami_name]
  }
}

data "aws_security_group" "consul" {
  filter {
    name   = "tag:Name"
    values = ["${var.project_name}-consul"]
  }
}

data "aws_secretsmanager_secret" "consul_ca_cert" {
  arn = var.consul_ca_cert_secret_arn
}

data "aws_secretsmanager_secret" "consul_gossip_key" {
  arn = var.consul_gossip_key_secret_arn
}

module "nomad" {
  source = "git::https://github.com/craigsloggett/terraform-aws-nomad-enterprise?ref=8cc4d9841f1f1ca69e6cc20cafd3b7a1fae4fe7a"

  project_name      = var.project_name
  route53_zone      = data.aws_route53_zone.nomad
  nomad_license     = var.nomad_license
  ec2_key_pair_name = var.ec2_key_pair_name
  ec2_ami           = data.aws_ami.selected

  existing_vpc = {
    vpc_id             = data.aws_vpc.selected.id
    private_subnet_ids = data.aws_subnets.private.ids
    public_subnet_ids  = data.aws_subnets.public.ids
  }

  consul_security_group    = data.aws_security_group.consul
  consul_ca_cert_secret    = data.aws_secretsmanager_secret.consul_ca_cert
  consul_gossip_key_secret = data.aws_secretsmanager_secret.consul_gossip_key
  consul_retry_join        = "provider=aws tag_key=consul-cluster tag_value=${var.project_name}"
  consul_datacenter        = var.consul_datacenter
  consul_package_version   = var.consul_package_version

  client_count            = var.client_count
  nlb_internal            = var.nlb_internal
  nomad_api_allowed_cidrs = var.nomad_api_allowed_cidrs
}
