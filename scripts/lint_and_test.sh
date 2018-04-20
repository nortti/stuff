#!/bin/bash
#
# Lint python code and shell scripts, and run tests.
# Also run coveralls if running from travis.

# cd to project root
cd "$(dirname "$0")/.."

shellcheck scripts/*.sh      # Shell script linting
flake8 hello_app tests       # Python code linting
pytest --cov=hello_app tests # Tests

if [[ -n "${TRAVIS}" ]]; then
    coveralls
fi


