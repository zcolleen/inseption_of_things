

VAGRANTFILE_API_VERSION = "2"
SHARED_HOST_FOLDER = "./confs"
SHARED_GUEST = "/zcolleen"

ENV['VAGRANT_DEFAULT_PROVIDER'] = 'virtualbox'


Vagrant.configure(VAGRANTFILE_API_VERSION) do |config|

  config.vm.box = "bento/centos-7"
  config.vm.boot_timeout = 120


  config.vm.define "zcolleenS" do |s|
    s.vm.provider "virtualbox" do |provider|
      provider.cpus = 1
      provider.memory = 1024

      provider.customize ["modifyvm", :id, "--name", "zcolleenS", "--natdnsproxy1", "on", "--natdnshostresolver1", "on"]
    end

    s.vm.network :private_network, ip: "192.168.42.110"
    s.vm.hostname = "zcolleenS"
    s.vm.provision "shell", inline: <<-SHELL
       curl -sfL https://get.k3s.io | sh -s - server \
       --write-kubeconfig-mode 0644 \
       --node-ip "192.168.42.110" \
       --flannel-iface eth1
       cp /var/lib/rancher/k3s/server/node-token #{SHARED_GUEST}/token
    SHELL

    s.vm.synced_folder SHARED_HOST_FOLDER, SHARED_GUEST, create: true
  end


  config.vm.define "zcolleenSW" do |sw|

    sw.vm.provider "virtualbox" do |provider|
      provider.cpus = 1
      provider.memory = 1024

      provider.customize ["modifyvm", :id, "--name", "zcolleenSW", "--natdnsproxy1", "on", "--natdnshostresolver1", "on"]
    end

    sw.vm.network :private_network, ip: "192.168.42.111"
    sw.vm.hostname = "zcolleenSW"
    sw.vm.provision "shell", inline: <<-SHELL
       curl -sfL https://get.k3s.io | sh -s - agent \
       --server "https://192.168.42.110:6443" \
       --node-ip "192.168.42.111" \
       --flannel-iface eth1 \
       --token-file #{SHARED_GUEST}/token
    SHELL

    sw.vm.synced_folder SHARED_HOST_FOLDER, SHARED_GUEST, create: true
  end

end
