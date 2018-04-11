# coding: utf-8
# -*- mode: ruby -*-
# vi: set ft=ruby :

Vagrant.configure("2") do |config|

  # Use the standard xenial base box for all VMs.
  config.vm.box = "ubuntu/xenial64"

  # Disable update checks – we don't want people to redownload boxes
  config.vm.box_check_update = false

  # The VM for edx-platform
  config.vm.define "edx" do |edx|
    edx.vm.network "private_network", ip: "192.168.33.10"
    config.vm.provider "virtualbox" do |vb|
      vb.memory = "1536"
    end
    config.vm.provision "shell", inline: <<-SHELL
      apt-get update
      apt-get install -y nginx python-virtualenv python-dev python-pip pkg-config g++ \
          build-essential curl nodejs libfreetype6-dev libffi-dev libsqlite3-dev

      # Create edxapp user and home directory
      mkdir -p /edx/app/
      id -u edxapp > /dev/null 2>&1 ||
          useradd --home-dir /edx/app/edxapp --create-home --shell /usr/sbin/nologin edxapp
      chown edxapp:www-data /edx/app/edxapp

      # Set up devpi-server
      pip install devpi-server
      [ -d /root/.devpi/server ] || devpi-server --init
      cd /tmp
      devpi-server --gen-config
      cp gen-config/devpi.service /etc/systemd/system/
      systemctl enable devpi.service
      systemctl start devpi.service

      # Install edx-platform and its Python and Node requirements.
      sudo -s -H -u edxapp <<EDXAPP
          cd
          mkdir -p ~/.pip
          cat > ~/.pip/pip.conf <<EOF
[global]
index-url = http://localhost:3141/root/pypi/+simple/
EOF
          virtualenv venvs/edxapp
          [ -d edx-platform ] || 
              git clone https://github.com/edx/edx-platform
          cd edx-platform
          git checkout 9a86a67ae0
          ../venvs/edxapp/bin/pip install -r requirements/edx/base.txt
          npm install
EDXAPP
SHELL
  end

  # The VM for all stateful services (MongoDB, MySQL, Redis, etc.)
  config.vm.define "db" do |db|
    db.vm.network "private_network", ip: "192.168.33.11"
    config.vm.provider "virtualbox" do |vb|
      vb.memory = "1536"
    end
  end

  # Share an additional folder to the guest VM. The first argument is
  # the path on the host to the actual folder. The second argument is
  # the path on the guest to mount the folder. And the optional third
  # argument is a set of non-required options.
  # config.vm.synced_folder "../data", "/vagrant_data"

end
