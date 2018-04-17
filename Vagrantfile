# coding: utf-8
# -*- mode: ruby -*-
# vi: set ft=ruby :

Vagrant.configure("2") do |config|

  # Use the standard xenial base box for all VMs.
  config.vm.box = "ubuntu/xenial64"

  # Disable update checks – we don't want people to redownload boxes
  config.vm.box_check_update = false

  # The VM for edx-platform
  config.vm.define "platform" do |platform|
    platform.vm.hostname = "platform"
    platform.vm.network "private_network", ip: "192.168.33.10"
    platform.vm.provider "virtualbox" do |vb|
      vb.memory = "1536"
    end
    platform.vm.provision "shell", inline: <<-SHELL
      if ! getent hosts services; then
          echo -e "192.168.33.11\tservices" >> /etc/hosts
      fi

      export DEBIAN_FRONTEND=noninteractive
      apt-get update
      apt-get install -y nginx python-virtualenv python-dev python-pip pkg-config g++ \
          build-essential curl nodejs libfreetype6-dev libffi-dev libsqlite3-dev \
          gfortran graphviz graphviz-dev liblapack-dev libmysqlclient-dev libxml2-dev \
          libgeos-dev libxslt1-dev gettext libjpeg8-dev libpng12-dev libxmlsec1-dev swig
      apt-get clean

      # Create edxapp user and home directory
      mkdir -p /edx/app/ /edx/var/edxapp
      id -u edxapp > /dev/null 2>&1 ||
          useradd --home-dir /edx/app/edxapp --create-home --shell /usr/sbin/nologin edxapp
      chown edxapp:www-data /edx/app/edxapp /edx/var/edxapp

      # Install edx-platform and its Python and Node requirements.
      sudo -s -H -u edxapp <<EDXAPP
          set -e

          # Clone edx-platform
          cd
          [ -d edx-platform ] || 
              git clone https://github.com/edx/edx-platform
          cd edx-platform
          git checkout release-2018-04-13-12.54

          # Install Python requirements in virtualenv
          virtualenv ../venvs/edxapp
          ../venvs/edxapp/bin/pip install -r requirements/edx/base.txt

          # Install Node requirements in nodeenv
          ../venvs/edxapp/bin/nodeenv ../nodeenvs/edxapp --node=8.9.3 --prebuilt --force
          . ../nodeenvs/edxapp/bin/activate
          npm install
          npm cache clean --force
          rm -rf ~/.cache
EDXAPP
SHELL
  end

  # The VM for all stateful services (MongoDB, MySQL, Redis, etc.)
  config.vm.define "services" do |services|
    services.vm.hostname = "services"
    services.vm.network "private_network", ip: "192.168.33.11"
    services.vm.provider "virtualbox" do |vb|
      vb.memory = "1536"
    end
    services.vm.provision "shell", inline: <<-SHELL
      if ! getent hosts platform; then
          echo -e "192.168.33.10\tplatform" >> /etc/hosts
      fi

      export DEBIAN_FRONTEND=noninteractive
      apt-get update
      apt-get install -y elasticsearch memcached mongodb-server mysql-server redis-server
      apt-get clean

      sed -i '/bind 127\.0\.0\.1/d' /etc/redis/redis.conf
      sed -i '/bind-address/d' /etc/mysql/mysql.conf.d/mysqld.cnf
      sed -i 's/.*bind_ip.*/bind_ip = 0.0.0.0/' /etc/mongodb.conf
      sed -i '/-l 127\.0\.0\.1/d' /etc/memcached.conf
SHELL
  end
end
