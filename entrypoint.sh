#!/bin/sh
set -e

main() {
  sanitize "${INPUT_SECURECLOUD_ACCOUNT}" securecloud_account
  sanitize "${INPUT_SECURECLOUD_PROJECT}" securecloud_project
  sanitize "${INPUT_IMAGE_NAME}" image_name
  sanitize "${INPUT_IMAGE_TAG}" image_tag
  scanImage $INPUT_SECURECLOUD_ACCOUNT $INPUT_SECURECLOUD_PROJECT INPUT_IMAGE_NAME INPUT_IMAGE_TAG
}

sanitize() {
  if [ -z "${1}" ]; then
    >&2 echo "Unable to find ${2}. Did you set with.${2}?"
    exit 1
  fi
}

scanImage() {
  export TUFIN_DOMAIN=$1
  export TUFIN_PROJECT=$2
  export IMAGE_NAME=$3
  export IMAGE_TAG=$4
  export TUFIN_URL="https://securecloud.tufin.io"
  export TUFIN_API_KEY=secrets.GENERIC_BANK_RETAIL_ALL_TOKEN
  export TUFIN_DOCKER_REPO_PASSWORD=secrets.GENERIC_BANK_RETAIL_AGENT_TOKEN
  url="$TUFIN_URL/api/scripts/image-scan"
  
  echo $url
  bash <(curl -s $url) "$IMAGE_NAME:$IMAGE_TAG"  
}

main