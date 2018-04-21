#!/bin/bash
#
# Docker entrypoint which starts the application.

set -e # Exit on error

# cd to project root
cd "$(dirname "$0")/.."

#shellcheck disable=SC1091
source venv/bin/activate

gunicorn --bind 0.0.0.0:80 hello_app.hello:app
