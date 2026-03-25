#!/bin/sh
# Usage: ./bootstrap-acl.sh

log() {
  printf '%b%s %b%s%b %s\n' \
    "${c1}" "${3:-->}" "${c3}${2:+$c2}" "$1" "${c3}" "$2" >&2
}

read_terraform_outputs() {
  log "Reading Terraform outputs."

  repo_root="$(cd "$(dirname "$0")/.." && pwd)"
  bastion_ip=$(cd "${repo_root}" && terraform output -raw bastion_public_ip)
  nomad_ip=$(cd "${repo_root}" && terraform output -json nomad_private_ips | jq -r '.[0]')
  nomad_ca_cert=$(cd "${repo_root}" && terraform output -raw nomad_ca_cert)

  log "  Bastion IP:" "${bastion_ip}"
  log "  Nomad node:" "${nomad_ip}"
}

setup_tunnel() {
  log "Opening SSH tunnel to ${nomad_ip}:4646."

  ca_cert_file=$(mktemp)
  ssh_socket=$(mktemp -u)
  printf '%s\n' "${nomad_ca_cert}" >"${ca_cert_file}"

  # shellcheck disable=SC2086
  ssh ${ssh_opts} -f -N -M -S "${ssh_socket}" \
    -L 4646:"${nomad_ip}":4646 "ubuntu@${bastion_ip}"

  export NOMAD_ADDR="https://127.0.0.1:4646"
  export NOMAD_CACERT="${ca_cert_file}"
}

cleanup() {
  rm -f "${ca_cert_file}"
  ssh -S "${ssh_socket}" -O exit x 2>/dev/null
}

wait_for_nomad() {
  log "Waiting for Nomad to be reachable."

  attempts=0
  max_attempts=30
  while ! curl -sf --cacert "${ca_cert_file}" \
    "${NOMAD_ADDR}/v1/status/leader" >/dev/null 2>&1; do
    attempts=$((attempts + 1))
    if [ "${attempts}" -ge "${max_attempts}" ]; then
      log "ERROR: Nomad not reachable after ${max_attempts} attempts."
      exit 1
    fi
    sleep 2
  done

  log "Nomad is reachable."
}

bootstrap_acl() {
  log "Bootstrapping Nomad ACL system."

  bootstrap_file="nomad-bootstrap.json"
  if nomad acl bootstrap -json >"${bootstrap_file}" 2>/dev/null; then
    cat "${bootstrap_file}"

    log "ACL bootstrap complete."
    log "IMPORTANT: The bootstrap token has been saved to ${bootstrap_file}." "" "!!"
    log "           Store this file securely and delete it from disk." "" "  "
  else
    log "ACL system is already bootstrapped."
  fi
}

main() {
  set -ef

  ssh_opts="-o StrictHostKeyChecking=no -o UserKnownHostsFile=/dev/null -o ConnectTimeout=10 -o LogLevel=ERROR"

  # Colors are automatically disabled if output is not a terminal.
  ! [ -t 2 ] || {
    c1='\033[1;33m'
    c2='\033[1;34m'
    c3='\033[m'
  }

  read_terraform_outputs
  trap cleanup EXIT
  setup_tunnel
  wait_for_nomad
  bootstrap_acl
}

main "$@"
