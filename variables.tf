variable "project_name" {
  type        = string
  description = "Name prefix for all resources."
}

variable "vpc_name" {
  type        = string
  description = "Name tag of the existing VPC."
}

variable "route53_zone_name" {
  type        = string
  description = "Name of the existing Route 53 hosted zone."
}

variable "nomad_license" {
  type        = string
  description = "Nomad Enterprise license string."
  sensitive   = true
}

variable "ec2_key_pair_name" {
  type        = string
  description = "Name of an existing EC2 key pair for SSH access."
}

variable "ec2_ami_owner" {
  type        = string
  description = "AWS account ID of the AMI owner."
}

variable "ec2_ami_name" {
  type        = string
  description = "Name filter for the AMI (supports wildcards)."
}

variable "nlb_internal" {
  type        = bool
  description = "Whether the NLB is internal."
  default     = true
}

variable "nomad_api_allowed_cidrs" {
  type        = list(string)
  description = "CIDR blocks allowed to reach the Nomad API (port 4646) from outside the VPC. Only effective when nlb_internal is false."
  default     = []
}

variable "nomad_server_instance_type" {
  type        = string
  description = "EC2 instance type for Nomad server nodes."
  default     = "m5.large"
}

# Consul Integration

variable "consul_ca_cert_secret_arn" {
  type        = string
  description = "ARN of the Secrets Manager secret containing the Consul CA certificate. Obtain from consul-enterprise-deploy output."
}

variable "consul_gossip_key_secret_arn" {
  type        = string
  description = "ARN of the Secrets Manager secret containing the Consul gossip encryption key. Obtain from consul-enterprise-deploy output."
}

variable "consul_token_secret_arn" {
  type        = string
  description = "ARN of the Secrets Manager secret containing the Consul ACL token for Nomad. Obtain from consul-enterprise-admin."
}

variable "consul_auto_join_ec2_tag" {
  type = object({
    key   = string
    value = string
  })
  description = "EC2 tag used for Consul cloud auto-join. Obtain from consul-enterprise-deploy output."
}

variable "consul_datacenter" {
  type        = string
  description = "Consul datacenter name."
  default     = "dc1"
}

variable "consul_version" {
  type        = string
  description = "Consul Enterprise release version for the local client agent."
  default     = "1.22.6+ent"
}

variable "nomad_server_service_name" {
  type        = string
  description = "Consul service name Nomad servers register as. Obtain from consul-enterprise-deploy output."
}

variable "nomad_client_service_name" {
  type        = string
  description = "Consul service name Nomad clients register as. Obtain from consul-enterprise-deploy output."
}

variable "nomad_snapshot_service_name" {
  type        = string
  description = "Consul service name the Nomad snapshot agent registers as. Obtain from consul-enterprise-deploy output."
}

# Nomad Client Nodes

variable "client_count" {
  type        = number
  description = "Number of Nomad client nodes to deploy."
  default     = 3
}

variable "nomad_client_instance_type" {
  type        = string
  description = "EC2 instance type for Nomad client nodes."
  default     = "m5.large"
}

# Vault Integration

variable "vault_url" {
  type        = string
  description = "Vault cluster URL (e.g., https://vault.example.com). Obtain from vault-enterprise-deploy output."
}

variable "vault_tls_ca_bundle_ssm_name" {
  type        = string
  description = "SSM parameter name holding the Vault cluster's TLS CA bundle. Obtain from vault-enterprise-deploy output."
}

variable "vault_iam_role_name" {
  type        = string
  description = "Name of the IAM role attached to Vault server nodes. Obtain from vault-enterprise-deploy output."
}
