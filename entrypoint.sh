#!/bin/sh
set -e

main() {
  sanitize "${INPUT_SECURECLOUD_ACCOUNT}" securecloud_account
  sanitize "${INPUT_SECURECLOUD_PROJECT}" securecloud_project
  sanitize "${INPUT_IMAGE}" image
  sanitize "${INPUT_TAG}" tag

  scanImage "${INPUT_SECURECLOUD_ACCOUNT}" "${INPUT_SECURECLOUD_PROJECT}" "${INPUT_IMAGE}" "${INPUT_TAG}" ${CVE_DETAILS}
}

sanitize() {
  if [ -z "${1}" ]; then
    >&2 echo "Unable to find ${2}. Please set ${2}."
    exit 1
  fi
}

scanImage() {
  export TUFIN_DOMAIN=${1}
  export TUFIN_PROJECT=${2}
  export IMAGE_NAME=${3}
  export IMAGE_TAG=${4}
  export CVE_DETAILS=${5}

  export TUFIN_URL="https://securecloud.tufin.io"
  url="${TUFIN_URL}/api/scripts/image-scan"

  curl -s $url > scan.sh
  result="$?"
  if [ "$result" -ne 0 ]; then
      echo "Failed to retrieve scan script from $url with exit code $result"
      exit 1
  fi

  bash scan.sh "${IMAGE_NAME}:${IMAGE_TAG}"  
  if [ "$result" -ne 0 ]; then
      echo "Scan failed with exit code $result"
      exit 1
  fi

  echo CVE="${CVE_DETAILS}"
  if [ "${CVE_DETAILS}" = "true" ]; then
      curl -H "Authorization: Bearer ${TUFIN_API_KEY}" -s "${TUFIN_URL}/cia/${TUFIN_DOMAIN}/${TUFIN_PROJECT}/scans/latest?image=${IMAGE_NAME}:${IMAGE_TAG}"
  fi
}

main
