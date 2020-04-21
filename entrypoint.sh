#!/bin/sh
set -e

main() {
  export TUFIN_URL="https://securecloud.tufin.io"
  url="$TUFIN_URL/api/scripts/image-scan"

  curl -s $url > scan.sh
  result="$?"
  if [ "$result" -ne 0 ]; then
      echo "Failed to retrieve scan script from $url with exit code $result"
      exit 1
  fi
  bash scan.sh "$IMAGE_NAME:$IMAGE_TAG"  
}

main
