# coding: utf-8
# -*- mode: ruby -*-
# vi: set ft=ruby :

Vagrant.configure("2") do |config|
  # Use the standard xenial base box for all VMs.
  config.vm.box = "ubuntu/xenial64"

  # Disable update checks – we don't want people to redownload boxes
  config.vm.box_check_update = false

  # Sync this folder so we can copy over some configuration.
  config.vm.synced_folder '.', '/vagrant', disabled: true
  config.vm.synced_folder '.', '/home/vagrant/edx-from-scratch'

  config.vm.provider "virtualbox" do |vb|
    vb.memory = "1234"

    # Downloads speeds within VMs are horrendous without these.
    vb.customize ["modifyvm", :id, "--natdnshostresolver1", "on"]
    vb.customize ["modifyvm", :id, "--natdnsproxy1", "on"]
    vb.customize ["modifyvm", :id, "--nictype1", "virtio"]
  end

  # The VM for all stateful services (MongoDB, MySQL, Redis, etc.)
  # We want the provisioner for this to run first, so the services are available to the platform.
  config.vm.define "services" do |services|
    services.vm.hostname = "services"
    services.vm.network "private_network", ip: "192.168.33.11"
    services.vm.provision "shell", path: "services.sh"
  end

  # The VM for edx-platform
  config.vm.define "platform", primary: true do |platform|
    platform.vm.hostname = "platform"
    platform.vm.network "private_network", ip: "192.168.33.10"
    platform.vm.network "forwarded_port", guest: 8000, host: 8000
    platform.vm.provision "shell", path: "platform.sh"

    # The edx-platform's memory requirements are a bit more beefy.
    # If deciding to run multiple services (LMS/CMS), this is needed.
    platform.vm.provider "virtualbox" do |vb|
      vb.memory = "2321"
    end
  end
end
