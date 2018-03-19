# -*- mode: ruby -*-
# vi: set ft=ruby :

# All Vagrant configuration is done below. The "2" in Vagrant.configure
# configures the configuration version (we support older styles for
# backwards compatibility). Please don't change it unless you know what
# you're doing.
$common_script = <<SCRIPT
apt-get update
apt-get install -qy python-pip docker.io
pip install -U pip
echo "192.168.121.201 aio" | sudo tee -a /etc/hosts
SCRIPT

$kolla_ansible_script = <<SCRIPT
apt-get update
apt-get install -qy python-dev libffi-dev gcc libssl-dev python-selinux
pip install -U ansible
pip install -U kolla-ansible
pip install python-openstackclient python-glanceclient python-neutronclient

# config
cp -r /usr/local/share/kolla-ansible/etc_examples/kolla /etc/kolla/
su -c 'cp /usr/local/share/kolla-ansible/ansible/inventory/* /home/vagrant' vagrant

# local settings
sed -i 's/^#kolla_base_distro:.*/kolla_base_distro: "ubuntu"/' /etc/kolla/globals.yml
sed -i 's/^#openstack_release:.*/openstack_release: "master"/' /etc/kolla/globals.yml
sed -i 's/^#kolla_install_type:.*/kolla_install_type: "source"/' /etc/kolla/globals.yml
sed -i 's/^kolla_internal_vip_address:.*/kolla_internal_vip_address: "192.168.121.254"/' /etc/kolla/globals.yml
sed -i 's/^#network_interface:.*/network_interface: "enp0s8"/' /etc/kolla/globals.yml
sed -i 's/^#neutron_external_interface:.*/neutron_external_interface: "enp0s9"/' /etc/kolla/globals.yml
sed -i 's/^#nova_compute_virt_type:.*/nova_compute_virt_type: "qemu"/' /etc/kolla/globals.yml

# VMware
# sed -i 's/^#nova_compute_virt_type:.*/nova_compute_virt_type: "vmware"/' /etc/kolla/globals.yml
# sed -i 's/^#enable_cinder:.*/enable_cinder: "yes"/' /etc/kolla/globals.yml
# sed -i 's/^#cinder_backend_vmwarevc_vmdk:.*/cinder_backend_vmwarevc_vmdk: "yes"/' /etc/kolla/globals.yml
# sed -i 's/^#vmware_vcenter_host_ip:.*/vmware_vcenter_host_ip: "10.44.147.160"/' /etc/kolla/globals.yml
# sed -i 's/^#vmware_vcenter_host_username:.*/vmware_vcenter_host_username: administrator@vsphere.local/' /etc/kolla/globals.yml
# sed -i 's/^#vmware_vcenter_host_password:.*/vmware_vcenter_host_password: W@pwap12/' /etc/kolla/globals.yml
# sed -i 's/^#vmware_datastore_name:.*/vmware_datastore_name: datastoreAFG/' /etc/kolla/globals.yml
# sed -i 's/^#vmware_vcenter_name:.*/vmware_vcenter_name: afglab/' /etc/kolla/globals.yml
# sed -i 's/^#vmware_vcenter_cluster_name:.*/vmware_vcenter_cluster_name: afglab-cluster1/' /etc/kolla/globals.yml

kolla-genpwd

# Disable ntp (caused bootstrap-servers hangning)
sed -i 's/^enable_host_ntp:.*/enable_host_ntp: False/' /usr/local/share/kolla-ansible/ansible/roles/baremetal/defaults/main.yml

# https://bugs.launchpad.net/kolla-ansible/+bug/1746748
patch /usr/local/share/kolla-ansible/ansible/library/kolla_docker.py < /vagrant/patch/mariadb_bootstrap.patch

# https://bugs.launchpad.net/kolla-ansible/+bug/1748347
patch /usr/local/share/kolla-ansible/ansible/roles/glance/tasks/bootstrap_service.yml < /vagrant/patch/glance_bootstrap.patch

# start deploy here
kolla-ansible -i /home/vagrant/all-in-one bootstrap-servers
kolla-ansible -i /home/vagrant/all-in-one prechecks
kolla-ansible -i /home/vagrant/all-in-one deploy

# kolla-ansible post-deploy
. /etc/kolla/admin-openrc.sh

. /usr/local/share/kolla-ansible/init-runonce

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
    vb.memory = 8192
  end

  config.vm.define vm_name = "aio" do |aio|
    aio.vm.hostname = "aio"
    aio.vm.network :private_network, ip: "192.168.121.201",nic_type: "virtio" # for API
    aio.vm.network :private_network, ip: "192.168.122.201",nic_type: "virtio" # for neutron  
    aio.vm.provision "shell", inline: $kolla_ansible_script
  end

  config.vm.provision "shell", inline: $common_script
end
