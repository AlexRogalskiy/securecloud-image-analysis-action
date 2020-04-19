#!/bin/sh
set -e

main() {
  sanitize "${INPUT_SECURECLOUD_ACCOUNT}" securecloud_account
  sanitize "${INPUT_SECURECLOUD_PROJECT}" securecloud_project
  echo "hola action ${INPUT_SECURECLOUD_ACCOUNT}/${INPUT_SECURECLOUD_PROJECT}"
}

sanitize() {
  if [ -z "${1}" ]; then
    >&2 echo "Unable to find ${2}. Did you set with.${2}?"
    exit 1
  fi
}

main