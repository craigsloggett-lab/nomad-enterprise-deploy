#!/bin/sh
# Usage: ./iterate-development.sh

log() {
  # Colors are automatically disabled if output is not a terminal
  ! [ -t 2 ] || {
    c1='\033[1;33m'
    c2='\033[1;34m'
    c3='\033[m'
  }

  printf '%b%s %b%s%b %s\n' \
    "${c1}" "${3:-->}" "${c3}${2:+$c2}" "$1" "${c3}" "$2" >&2
}

read_terraform_outputs() {
  log "Reading Terraform outputs."

  # Switch to the Terraform root directory.
  cd "$(dirname "$0")/.."

  terraform_output="$(terraform output -json)"
  server_asg_name="$(
    printf '%s\n' "${terraform_output}" |
      jq -r '.nomad_server_asg_name.value'
  )"
  client_asg_name="$(
    printf '%s\n' "${terraform_output}" |
      jq -r '.nomad_client_asg_name.value'
  )"
  log "  Server ASG:" "${server_asg_name}"
  log "  Client ASG:" "${client_asg_name}"
}

wait_for_asg_empty() {
  log "Waiting for ASG to scale down:" "$1"
  while :; do
    count="$(aws autoscaling describe-auto-scaling-groups \
      --auto-scaling-group-names "$1" \
      --query 'length(AutoScalingGroups[0].Instances)' \
      --output text)"
    [ "${count}" = "0" ] && break
    sleep 10
  done
  log "  ASG is empty."
}

scale_down_asg() {
  log "Scaling down ASG:" "$1"

  # Scale the ASG down to 0
  aws autoscaling update-auto-scaling-group \
    --auto-scaling-group-name "$1" \
    --min-size 0 --desired-capacity 0

  # Grab the current instance IDs
  ids="$(
    aws autoscaling describe-auto-scaling-groups \
      --auto-scaling-group-names "$1" \
      --query 'AutoScalingGroups[0].Instances[*].InstanceId' \
      --output text |
      tr '\t' '\n'
  )"

  # shellcheck disable=SC2086
  # Nuke them to speed up the scale down
  [ -n "${ids}" ] && aws ec2 terminate-instances --instance-ids ${ids}

  wait_for_asg_empty "$1"
}

delete_coordination_ssm_parameters() {
  log "Deleting coordination SSM parameters."

  names="$(aws ssm describe-parameters \
    --parameter-filters "Key=Name,Option=BeginsWith,Values=/lab/nomad/" \
    --query 'Parameters[].Name' --output text)"

  if [ -z "${names}" ]; then
    log "  Nothing to delete."
    return 0
  fi

  log "  Deleting:" "$(printf '%s' "${names}" | tr '\t' ' ')"
  # shellcheck disable=SC2086
  aws ssm delete-parameters --names ${names} >/dev/null
}

main() {
  set -ef

  # Read Terraform outputs
  read_terraform_outputs

  # Tear down both ASGs
  scale_down_asg "${server_asg_name}"
  scale_down_asg "${client_asg_name}"

  delete_coordination_ssm_parameters
}

main "$@"
