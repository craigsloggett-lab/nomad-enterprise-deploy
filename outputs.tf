output "nomad_url" {
  description = "URL of the Nomad cluster."
  value       = module.nomad.nomad_url
}

output "bastion_public_ip" {
  description = "Public IP of the bastion host."
  value       = module.nomad.bastion_public_ip
}

output "nomad_server_private_ips" {
  description = "Private IPs of the Nomad server nodes."
  value       = module.nomad.nomad_server_private_ips
}

output "nomad_target_group_arn" {
  description = "ARN of the Nomad NLB target group."
  value       = module.nomad.nomad_target_group_arn
}

output "ec2_ami_name" {
  description = "Name of the AMI used for EC2 instances."
  value       = module.nomad.ec2_ami_name
}

output "nomad_ca_cert" {
  description = "CA certificate for trusting the Nomad TLS chain."
  value       = module.nomad.nomad_ca_cert
  sensitive   = true
}

output "nomad_client_asg_name" {
  description = "Name of the Nomad client Auto Scaling Group."
  value       = module.nomad.nomad_client_asg_name
}

output "nomad_intro_token_secret_arn" {
  description = "ARN of the Secrets Manager secret for the client introduction ACL token."
  value       = module.nomad.nomad_intro_token_secret_arn
}

output "nomad_snapshot_token_secret_arn" {
  description = "ARN of the Secrets Manager secret for the snapshot agent ACL token."
  value       = module.nomad.nomad_snapshot_token_secret_arn
}

output "nomad_autoscaler_token_secret_arn" {
  description = "ARN of the Secrets Manager secret for the autoscaler ACL token."
  value       = module.nomad.nomad_autoscaler_token_secret_arn
}
