#!/bin/bash
#
# Update requirements-files for all envs
# Usage: scripts/update_requirements.sh

set -e # Exit on error

# Used by pip-compile to generate instructions in it's output
CUSTOM_COMPILE_COMMAND="scripts/$(basename "$0")"
export CUSTOM_COMPILE_COMMAND

for in_file in ../requirements/*.in
do
  out_file="${in_file%.in}.txt"
  pip-compile --generate-hashes --output-file "$out_file" "$in_file"
done
