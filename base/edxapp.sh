#!/usr/bin/env bash

set -e

# Clone edx-platform
cd
[ -d edx-platform ] ||
git clone --branch release-2018-04-18-11.24 --depth 1 https://github.com/edx/edx-platform
cd edx-platform

# Install Python requirements in virtualenv
virtualenv ~/venvs/edxapp
. ~/venvs/edxapp/bin/activate
pip install -r requirements/edx/base.txt

# Install Node requirements in nodeenv
~/venvs/edxapp/bin/nodeenv ../nodeenvs/edxapp --node=8.9.3 --prebuilt --force
. ~/nodeenvs/edxapp/bin/activate
npm install
npm cache clean --force
rm -rf ~/.cache

# Install environment variables
tee ~/.bashrc ~/edxapp_env << ENVIRONMENT
export LANG="en_US.UTF-8"
export PATH="/edx/app/edxapp/venvs/edxapp/bin:/edx/app/edxapp/edx-platform/bin:/edx/app/edxapp/edx-platform/node_modules/.bin:/edx/app/edxapp/nodeenvs/edxapp/bin:/usr/local/sbin:/usr/local/bin:/usr/sbin:/usr/bin:/sbin:/bin"
export EDX_PLATFORM_SETTINGS="devstack"
export CONFIG_ROOT="/edx/app/edxapp"
export SERVICE_VARIANT="lms"
export DJANGO_SETTINGS_MODULE=lms.envs.devstack
ENVIRONMENT

source ~/.bashrc

# Migrate DB
python manage.py lms migrate --settings=devstack

# Collect assets
paver update_assets --settings devstack
