#!/bin/bash

# This script automates the creation and installation
# of the conda environmnet. It's useful for working
# in the docker file and on travis, but it's not
# necessary for individual users to use it.

# Developers are encouraged to only run scripts
# that they fully understand, and may prefer to
# run aspects of this script manually to set-up
# openwpm.

# This script will remove an existing openwpm
# conda environment if it exists.

# Arguments:
# --skip-create: Doesn't change the openwpm conda environment


set -e

# Make conda available to shell script
eval "$(conda shell.bash hook)"

if [ "$1" != "--skip-create" ]; then
  echo 'Creating / Overwriting openwpm conda environment.'
  # `PYTHONNOUSERSITE` set so python ignores local user site libraries when building the env
  # See: https://github.com/mozilla/OpenWPM/pull/682#issuecomment-645648939
  conda env remove --name openwpm -y || true
  PYTHONNOUSERSITE=True conda env create --yes -q -f environment.yaml -v
fi

echo 'Activating environment.'
conda activate openwpm

python3 -m pip install python_levenshtein adblockparser openwpm_utils

echo 'Installing firefox.'
./scripts/install-firefox.sh

echo 'Building extension.'
./scripts/build-extension.sh

echo 'Installation complete, activate your new environment by running:'
echo 'conda activate openwpm'
