#!/bin/bash
#
# Installs the appropriate dependencies. In dev, does it in a virtualenv.
# Usage: scripts/install.sh [dev|travis|prod]

readonly DEV_ENV_NAME='dev'
readonly TRAVIS_ENV_NAME='travis'
readonly PROD_ENV_NAME='prod'

set -e # Exit on error

print_env() {
  local env_arg="$1"
  case "${env_arg}" in
    "${TRAVIS_ENV_NAME}") echo "${TRAVIS_ENV_NAME}" ;;
    "${PROD_ENV_NAME}") echo "${PROD_ENV_NAME}" ;;
    *) echo "${DEV_ENV_NAME}" ;;
  esac
}

cd_to_project_root() {
  cd "$(dirname "$0")/.."
}

create_and_source_venv() {
  rm -rf ./venv
  virtualenv venv
  # shellcheck disable=SC1091
  source venv/bin/activate
}

install_requirements() {
  local env="$1"
  pip install pip-tools # Includes pip-sync
  pip-sync requirements/common-requirements.txt \
    requirements/"${env}"-requirements.txt
}

main() {
  local env
  env="$(print_env "$1")"
  echo Using env: "${env}"

  cd_to_project_root

  if [[ "${env}" = "${DEV_ENV_NAME}" ]]; then
    create_and_source_venv
  fi

  install_requirements "${env}"
}

main "$@"
