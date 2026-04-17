# terraform-root-module-template

A GitHub repository template for creating new Terraform root module.

## Usage

The following files require your attention immediately after creating a
repository from this template:

- [ ] .github/CODEOWNERS
- [ ] .github/dependabot.yml
- [ ] .github/workflows/lint.yml
- [ ] backend.tf
- [ ] README.md

<!-- BEGIN_TF_DOCS -->
## Requirements

| Name | Version |
| ---- | ------- |
| <a name="requirement_terraform"></a> [terraform](#requirement\_terraform) | ~> 1.7 |
| <a name="requirement_aws"></a> [aws](#requirement\_aws) | ~> 6.0 |

## Providers

| Name | Version |
| ---- | ------- |
| <a name="provider_aws"></a> [aws](#provider\_aws) | ~> 6.0 |

## Modules

| Name | Source | Version |
| ---- | ------ | ------- |
| <a name="module_nomad"></a> [nomad](#module\_nomad) | git::https://github.com/craigsloggett/terraform-aws-nomad-enterprise | c706726cf85163306b82942ac01342b7fe44be95 |

## Inputs

| Name | Description | Type | Default | Required |
| ---- | ----------- | ---- | ------- | :------: |
| <a name="input_client_count"></a> [client\_count](#input\_client\_count) | Number of Nomad client nodes to deploy. | `number` | `3` | no |
| <a name="input_consul_auto_join_ec2_tag"></a> [consul\_auto\_join\_ec2\_tag](#input\_consul\_auto\_join\_ec2\_tag) | EC2 tag used for Consul cloud auto-join. Obtain from consul-enterprise-deploy output. | <pre>object({<br/>    key   = string<br/>    value = string<br/>  })</pre> | n/a | yes |
| <a name="input_consul_datacenter"></a> [consul\_datacenter](#input\_consul\_datacenter) | Consul datacenter name. | `string` | `"dc1"` | no |
| <a name="input_consul_gossip_key_secret_arn"></a> [consul\_gossip\_key\_secret\_arn](#input\_consul\_gossip\_key\_secret\_arn) | ARN of the Secrets Manager secret containing the Consul gossip encryption key. Obtain from consul-enterprise-deploy output. | `string` | n/a | yes |
| <a name="input_consul_token_secret_arn"></a> [consul\_token\_secret\_arn](#input\_consul\_token\_secret\_arn) | ARN of the Secrets Manager secret containing the Consul ACL token for Nomad. Obtain from consul-enterprise-admin. | `string` | n/a | yes |
| <a name="input_consul_version"></a> [consul\_version](#input\_consul\_version) | Consul Enterprise release version for the local client agent. | `string` | `"1.22.6+ent"` | no |
| <a name="input_ec2_ami_name"></a> [ec2\_ami\_name](#input\_ec2\_ami\_name) | Name filter for the AMI (supports wildcards). | `string` | n/a | yes |
| <a name="input_ec2_ami_owner"></a> [ec2\_ami\_owner](#input\_ec2\_ami\_owner) | AWS account ID of the AMI owner. | `string` | n/a | yes |
| <a name="input_ec2_key_pair_name"></a> [ec2\_key\_pair\_name](#input\_ec2\_key\_pair\_name) | Name of an existing EC2 key pair for SSH access. | `string` | n/a | yes |
| <a name="input_nlb_internal"></a> [nlb\_internal](#input\_nlb\_internal) | Whether the NLB is internal. | `bool` | `true` | no |
| <a name="input_nomad_api_allowed_cidrs"></a> [nomad\_api\_allowed\_cidrs](#input\_nomad\_api\_allowed\_cidrs) | CIDR blocks allowed to reach the Nomad API (port 4646) from outside the VPC. Only effective when nlb\_internal is false. | `list(string)` | `[]` | no |
| <a name="input_nomad_client_instance_type"></a> [nomad\_client\_instance\_type](#input\_nomad\_client\_instance\_type) | EC2 instance type for Nomad client nodes. | `string` | `"m5.large"` | no |
| <a name="input_nomad_client_service_name"></a> [nomad\_client\_service\_name](#input\_nomad\_client\_service\_name) | Consul service name Nomad clients register as. Obtain from consul-enterprise-deploy output. | `string` | n/a | yes |
| <a name="input_nomad_license"></a> [nomad\_license](#input\_nomad\_license) | Nomad Enterprise license string. | `string` | n/a | yes |
| <a name="input_nomad_server_instance_type"></a> [nomad\_server\_instance\_type](#input\_nomad\_server\_instance\_type) | EC2 instance type for Nomad server nodes. | `string` | `"m5.large"` | no |
| <a name="input_nomad_server_service_name"></a> [nomad\_server\_service\_name](#input\_nomad\_server\_service\_name) | Consul service name Nomad servers register as. Obtain from consul-enterprise-deploy output. | `string` | n/a | yes |
| <a name="input_nomad_snapshot_service_name"></a> [nomad\_snapshot\_service\_name](#input\_nomad\_snapshot\_service\_name) | Consul service name the Nomad snapshot agent registers as. Obtain from consul-enterprise-deploy output. | `string` | n/a | yes |
| <a name="input_project_name"></a> [project\_name](#input\_project\_name) | Name prefix for all resources. | `string` | n/a | yes |
| <a name="input_route53_zone_name"></a> [route53\_zone\_name](#input\_route53\_zone\_name) | Name of the existing Route 53 hosted zone. | `string` | n/a | yes |
| <a name="input_vault_iam_role_name"></a> [vault\_iam\_role\_name](#input\_vault\_iam\_role\_name) | Name of the IAM role attached to Vault server nodes. Obtain from vault-enterprise-deploy output. | `string` | n/a | yes |
| <a name="input_vault_tls_ca_bundle_ssm_name"></a> [vault\_tls\_ca\_bundle\_ssm\_name](#input\_vault\_tls\_ca\_bundle\_ssm\_name) | SSM parameter name holding the Vault cluster's TLS CA bundle. Obtain from vault-enterprise-deploy output. | `string` | n/a | yes |
| <a name="input_vault_url"></a> [vault\_url](#input\_vault\_url) | Vault cluster URL (e.g., https://vault.example.com). Obtain from vault-enterprise-deploy output. | `string` | n/a | yes |
| <a name="input_vpc_name"></a> [vpc\_name](#input\_vpc\_name) | Name tag of the existing VPC. | `string` | n/a | yes |

## Resources

| Name | Type |
| ---- | ---- |
| [aws_ami.selected](https://registry.terraform.io/providers/hashicorp/aws/latest/docs/data-sources/ami) | data source |
| [aws_route53_zone.nomad](https://registry.terraform.io/providers/hashicorp/aws/latest/docs/data-sources/route53_zone) | data source |
| [aws_secretsmanager_secret.consul_gossip_key](https://registry.terraform.io/providers/hashicorp/aws/latest/docs/data-sources/secretsmanager_secret) | data source |
| [aws_secretsmanager_secret.consul_token](https://registry.terraform.io/providers/hashicorp/aws/latest/docs/data-sources/secretsmanager_secret) | data source |
| [aws_security_group.consul](https://registry.terraform.io/providers/hashicorp/aws/latest/docs/data-sources/security_group) | data source |
| [aws_subnets.private](https://registry.terraform.io/providers/hashicorp/aws/latest/docs/data-sources/subnets) | data source |
| [aws_subnets.public](https://registry.terraform.io/providers/hashicorp/aws/latest/docs/data-sources/subnets) | data source |
| [aws_vpc.selected](https://registry.terraform.io/providers/hashicorp/aws/latest/docs/data-sources/vpc) | data source |

## Outputs

| Name | Description |
| ---- | ----------- |
| <a name="output_bastion_public_ip"></a> [bastion\_public\_ip](#output\_bastion\_public\_ip) | Public IP of the bastion host. |
| <a name="output_ec2_ami_name"></a> [ec2\_ami\_name](#output\_ec2\_ami\_name) | Name of the AMI used for EC2 instances. |
| <a name="output_nomad_autoscaler_token_secret_arn"></a> [nomad\_autoscaler\_token\_secret\_arn](#output\_nomad\_autoscaler\_token\_secret\_arn) | ARN of the Secrets Manager secret for the autoscaler ACL token. |
| <a name="output_nomad_ca_cert"></a> [nomad\_ca\_cert](#output\_nomad\_ca\_cert) | CA certificate for trusting the Nomad TLS chain. |
| <a name="output_nomad_client_asg_name"></a> [nomad\_client\_asg\_name](#output\_nomad\_client\_asg\_name) | Name of the Nomad client Auto Scaling Group. |
| <a name="output_nomad_intro_token_secret_arn"></a> [nomad\_intro\_token\_secret\_arn](#output\_nomad\_intro\_token\_secret\_arn) | ARN of the Secrets Manager secret for the client introduction ACL token. |
| <a name="output_nomad_server_private_ips"></a> [nomad\_server\_private\_ips](#output\_nomad\_server\_private\_ips) | Private IPs of the Nomad server nodes. |
| <a name="output_nomad_snapshot_token_secret_arn"></a> [nomad\_snapshot\_token\_secret\_arn](#output\_nomad\_snapshot\_token\_secret\_arn) | ARN of the Secrets Manager secret for the snapshot agent ACL token. |
| <a name="output_nomad_target_group_arn"></a> [nomad\_target\_group\_arn](#output\_nomad\_target\_group\_arn) | ARN of the Nomad NLB target group. |
| <a name="output_nomad_url"></a> [nomad\_url](#output\_nomad\_url) | URL of the Nomad cluster. |
<!-- END_TF_DOCS -->
