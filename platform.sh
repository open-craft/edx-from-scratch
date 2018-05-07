#!/usr/bin/env bash

set -e

if ! getent hosts services; then
  echo -e "192.168.33.10\tlms.local" >> /etc/hosts
  echo -e "192.168.33.11\tservices" >> /etc/hosts
fi

export DEBIAN_FRONTEND=noninteractive

# Install required packages
apt-get update
apt-get install -y nginx python-virtualenv python-dev python-pip pkg-config g++ \
  build-essential curl nodejs libfreetype6-dev libffi-dev libsqlite3-dev \
  gfortran graphviz graphviz-dev liblapack-dev libmysqlclient-dev libxml2-dev \
  libgeos-dev libxslt1-dev gettext libjpeg8-dev libpng12-dev libxmlsec1-dev swig \
  s3cmd apparmor-utils ipython ntp
apt-get clean

# Create all directories
mkdir -p \
    /edx/var/edxapp/{staticfiles,themes,media,course_static,uploads,data} \
    /edx/var/log/{lms,cms} \
    /edx/app/edxapp/{venvs,nodeenvs}/edxapp

# Copy over environment files
cp ~vagrant/edx-from-scratch/lms.{env,auth}.json /edx/app/edxapp

# Handle user creation and permissions
id -u edxapp > /dev/null 2>&1 ||
  useradd --home-dir /edx/app/edxapp --create-home --shell /usr/sbin/nologin edxapp
chown -R edxapp:www-data /edx/{app,var}/edxapp
chown -R syslog:syslog   /edx/var/log

# Install edx-platform.
sudo -Hsu edxapp ~vagrant/edx-from-scratch/edxapp.sh
