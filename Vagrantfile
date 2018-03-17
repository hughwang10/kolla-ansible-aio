# -*- mode: ruby -*-
# vi: set ft=ruby :

# All Vagrant configuration is done below. The "2" in Vagrant.configure
# configures the configuration version (we support older styles for
# backwards compatibility). Please don't change it unless you know what
# you're doing.
$common_script = <<SCRIPT
apt-get update
apt-get install -qy docker.io
# apt-get update && apt-get install -y apt-transport-https
# curl -s https://packages.cloud.google.com/apt/doc/apt-key.gpg | apt-key add -
# echo "deb http://apt.kubernetes.io/ kubernetes-xenial main" >/etc/apt/sources.list.d/kubernetes.list
# apt-get update
# apt-get install -y kubelet kubeadm kubectl
echo "192.168.121.201 c1" | sudo tee -a /etc/hosts
# echo "192.168.121.202 w1" | sudo tee -a /etc/hosts
SCRIPT

$kolla_ansible_script = <<SCRIPT
apt-get update
apt-get install -qy python-pip python-dev libffi-dev gcc libssl-dev python-selinux
pip install -U pip
pip install -U ansible
pip install -U kolla-ansible
cp -r /usr/local/share/kolla-ansible/etc_examples/kolla /etc/kolla/
su -c 'cp /usr/local/share/kolla-ansible/ansible/inventory/* /home/vagrant' vagrant
SCRIPT

# $ctrl_script = <<SCRIPT
# sudo kubeadm init --pod-network-cidr=10.244.0.0/16 --apiserver-advertise-address=192.168.121.201
# mkdir -p $HOME/.kube
# sudo cp /etc/kubernetes/admin.conf $HOME/.kube/config
# sudo chown $(id -u):$(id -g) $HOME/.kube/config
# mkdir -p /home/vagrant/.kube
# sudo cp /etc/kubernetes/admin.conf /home/vagrant/.kube/config
# sudo chown vagrant:vagrant /home/vagrant/.kube/config
# # canal
# kubectl apply -f /vagrant/rbac.yaml
# kubectl apply -f /vagrant/canal.yaml
# kubectl taint nodes --all node-role.kubernetes.io/master-
# kubectl version
# # Helm
# curl -s https://raw.githubusercontent.com/kubernetes/helm/master/scripts/get > /var/tmp/get_helm.sh
# chmod 700 /var/tmp/get_helm.sh
# /var/tmp/get_helm.sh
# su -c 'helm init' vagrant
# kubectl create serviceaccount --namespace kube-system tiller
# kubectl create clusterrolebinding tiller-cluster-rule --clusterrole=cluster-admin --serviceaccount=kube-system:tiller
# kubectl patch deploy --namespace kube-system tiller-deploy -p '{"spec":{"template":{"spec":{"serviceAccount":"tiller"}}}}'
# SCRIPT

# $fuel_ccp_script = <<SCRIPT
# usermod -a -G docker vagrant
# apt-get install -y python-pip python-dev python3-dev python-netaddr software-properties-common python-setuptools gcc
# pip install --upgrade pip
# pip install /vagrant/fuel-ccp/
# SCRIPT

# $kolla_script = <<SCRIPT
# apt-get install -y ansible python-pip python-dev
# pip install --upgrade pip
# pip install -U /vagrant/kolla-ansible/ /vagrant/kolla-kubernetes/
# cp -aR /usr/local/share/kolla-ansible/etc_examples/kolla/ /etc
# cp -aR /vagrant/kolla-kubernetes/etc/kolla-kubernetes/ /etc
# kolla-kubernetes-genpwd
# kubectl create namespace kolla
# kubectl label node $(hostname) kolla_compute=true
# kubectl label node $(hostname) kolla_controller=true
# SCRIPT

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

  config.vm.define vm_name = "c1" do |c1|
    c1.vm.hostname = "c1"
    c1.vm.network :private_network, ip: "192.168.121.201",nic_type: "virtio"
    c1.vm.network :private_network, ip: "192.168.122.201",nic_type: "virtio"
    # c1.vm.network "forwarded_port", guest: 8001, host: 8001, host_ip: "127.0.0.1"
    # c1.vm.provision "shell", inline: $ctrl_script
    # c1.vm.provision "shell", inline: $fuel_ccp_script    
    c1.vm.provision "shell", inline: $kolla_ansible_script
  end

  config.vm.provision "shell", inline: $common_script
end
