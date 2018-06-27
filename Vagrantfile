# -*- mode: ruby -*-
# vi: set ft=ruby :

# All Vagrant configuration is done below. The "2" in Vagrant.configure
# configures the configuration version (we support older styles for
# backwards compatibility). Please don't change it unless you know what
# you're doing.
$common_script = <<SCRIPT
sudo apt-get update
sudo apt-get install -qy python-pip docker.io apt-transport-https
sudo -H pip install -U pip
sudo -H pip install ansible
sudo -H pip install docker-compose
ansible-playbook /vagrant/playbook.yml
SCRIPT

Vagrant.configure("2") do |config|
  # The most common configuration options are documented and commented below.
  # For a complete reference, please see the online documentation at
  # https://docs.vagrantup.com.

  # Every Vagrant development environment requires a box. You can search for
  # boxes at https://vagrantcloud.com/search.
  config.vm.box = "ubuntu/xenial64"
  config.ssh.insert_key = false # same key

  config.vm.provider :virtualbox do |vb|
    vb.cpus = 2
    vb.gui = false
    vb.memory = 4096
  end

  config.vm.define vm_name = "aio" do |aio|
    aio.vm.hostname = "aio"
    aio.vm.network :private_network, ip: "192.168.121.201",nic_type: "virtio" # for API
    # aio.vm.network :private_network, ip: "192.168.122.201",nic_type: "virtio" # for neutron
    # aio.vm.provision "shell", inline: $kolla_ansible_script
  end

  config.vm.provision "shell", inline: $common_script
end
