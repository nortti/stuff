#!/bin/bash
#
# Lint python code, shell scripts, html, and run tests.
# Also run coveralls if running from travis.

set -e

# cd to project root
cd "$(dirname "$0")/.."

# Shell script linting
shellcheck scripts/*.sh

# Python code linting
flake8 hello_app tests

# html linting
html_lint.py hello_app/templates/*.html

# Python tests
pytest --cov=hello_app tests

if [[ -n "${TRAVIS}" ]]; then
    coveralls
fi


