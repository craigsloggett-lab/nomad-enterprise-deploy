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

data "aws_secretsmanager_secret" "consul_gossip_key" {
  arn = data.tfe_outputs.consul_enterprise_deploy.values.consul_gossip_key_secret_arn
}

data "aws_secretsmanager_secret" "consul_token" {
  arn = data.tfe_outputs.consul_enterprise_deploy.values.consul_token_secret_arn
}

data "tfe_organization" "this" {
  name = "craigsloggett-lab"
}

data "tfe_workspace" "vault_enterprise_deploy" {
  organization = data.tfe_organization.this.name
  name         = "vault-enterprise-deploy"
}

data "tfe_workspace" "consul_enterprise_deploy" {
  organization = data.tfe_organization.this.name
  name         = "consul-enterprise-deploy"
}

data "tfe_outputs" "vault_enterprise_deploy" {
  organization = data.tfe_organization.this.name
  workspace    = data.tfe_workspace.vault_enterprise_deploy.name
}

data "tfe_outputs" "consul_enterprise_deploy" {
  organization = data.tfe_organization.this.name
  workspace    = data.tfe_workspace.consul_enterprise_deploy.name
}

module "nomad" {
  # tflint-ignore: terraform_module_pinned_source
  source = "git::https://github.com/craigsloggett/terraform-aws-nomad-enterprise?ref=81affe5042d9cff13e542976e692a67d8d900174"

  project_name               = var.project_name
  route53_zone               = data.aws_route53_zone.nomad
  nomad_enterprise_license   = var.nomad_enterprise_license
  ec2_key_pair_name          = var.ec2_key_pair_name
  ec2_ami                    = data.aws_ami.selected
  nomad_server_instance_type = var.nomad_server_instance_type

  existing_vpc = {
    vpc_id             = data.aws_vpc.selected.id
    private_subnet_ids = data.aws_subnets.private.ids
    public_subnet_ids  = data.aws_subnets.public.ids
  }

  consul_security_group    = data.aws_security_group.consul
  consul_gossip_key_secret = data.aws_secretsmanager_secret.consul_gossip_key
  consul_token_secret      = data.aws_secretsmanager_secret.consul_token
  consul_auto_join_ec2_tag = data.tfe_outputs.consul_enterprise_deploy.values.consul_auto_join_ec2_tag
  consul_datacenter        = data.tfe_outputs.consul_enterprise_deploy.values.consul_datacenter
  consul_version           = data.tfe_outputs.consul_enterprise_deploy.values.consul_version

  nomad_server_service_name                  = data.tfe_outputs.consul_enterprise_deploy.values.nomad_server_service_name
  nomad_client_service_name                  = data.tfe_outputs.consul_enterprise_deploy.values.nomad_client_service_name
  nomad_operator_snapshot_agent_service_name = data.tfe_outputs.consul_enterprise_deploy.values.nomad_operator_snapshot_agent_service_name

  vault_tls_ca_bundle_ssm_parameter_name = data.tfe_outputs.vault_enterprise_deploy.values.vault_tls_ca_bundle_ssm_parameter_name
  vault_iam_role_name                    = data.tfe_outputs.vault_enterprise_deploy.values.vault_iam_role_name
  vault_url                              = data.tfe_outputs.vault_enterprise_deploy.values.vault_url

  client_count               = var.client_count
  nlb_internal               = var.nlb_internal
  nomad_api_allowed_cidrs    = var.nomad_api_allowed_cidrs
  nomad_client_instance_type = var.nomad_client_instance_type
}
