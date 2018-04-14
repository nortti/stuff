#!/bin/bash
#
# Deploy the application to staging or production from travis.

readonly image="$1"
readonly port="$2"

set -e # Exit on error

docker_build_push() {
  echo "${DOCKER_PASS}" | docker login -u="${DOCKER_USER}" --password-stdin
  docker build -t "${DOCKER_USER}/${image}" \
    -f Dockerfile \
    --build-arg port="${port}" .
  docker push "${DOCKER_USER}/${image}"
}

docker_remote_pull_deploy() {
  # Free travis doesn't feature ssh keys. Workaround is to store them as
  # environment variables. Instead of escaping special characters we've
  # stored the key in base64-format.
  echo "${ID_RSA}" | base64 --decode > id_rsa
  chmod 600 id_rsa

  # Pull and run a docker container over ssh
  # shellcheck disable=SC2087,SC2029
  ssh -i id_rsa \
    -o StrictHostKeyChecking=no \
    "${PROD_USER}@${PROD_ADDRESS}" << EOF
      echo "${DOCKER_PASS}" | docker login -u="${DOCKER_USER}" --password-stdin
      docker pull "${DOCKER_USER}/${image}"
      docker rm -f "${image}"
      docker run -d
        -p "${port}:${port}"
        --name "${image}"
        "${DOCKER_USER}/${image}"
EOF
  rm id_rsa
}

main() {
  if [[ -z "${TRAVIS}" ]]; then
    echo 'This script is meant to be run from travis only!' >&2
    exit 1
  fi

  docker_build_push
  docker_remote_pull_deploy
}

main "$@"
