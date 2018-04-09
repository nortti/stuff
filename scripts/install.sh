#!/bin/bash
#
# Installs the appropriate dependencies. In dev, does it in a virtualenv.
# Usage: scripts/install.sh [dev|travis|prod]

# cd to project root (i.e. one level below this script)
dir=$(dirname "$0")
cd "$dir"/.. || exit 1

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
    . venv/bin/activate
fi

# Pip-sync required for pip tools
pip install pip-tools
pip-sync requirements/common-requirements.txt \
         requirements/"$env"-requirements.txt

if [ "$env" == "dev" ]; then
    echo Now run: source venv/bin/activate
fi
