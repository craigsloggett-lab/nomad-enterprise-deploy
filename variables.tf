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

variable "nomad_enterprise_license" {
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
