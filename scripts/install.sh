#!/bin/bash
#
# Installs the appropriate dependencies. In dev, does it in a virtualenv.
# Usage: scripts/install.sh [dev|travis|prod]

# Run from one level above this script
cd "$(dirname "$0")/.." || exit 1

# Default env is dev
if [ -z "$1" ]; then
    env=dev
else
    env="$1"
fi

if [ "$env" == "dev" ]; then
    rm -rf ./venv
    # Symlink your python 2 installation to python2 if necessary
    virtualenv -p python2 venv
    source venv/bin/activate
fi

# Pip-tools required for pip sync
pip install pip-tools
pip-sync requirements/common-requirements.txt \
         requirements/"$env"-requirements.txt

if [ "$env" == "dev" ]; then
    echo Now run: source venv/bin/activate
fi
