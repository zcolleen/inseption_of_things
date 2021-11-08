

VAGRANTFILE_API_VERSION = "2"
SHARED_HOST_FOLDER = "./token"

ENV['VAGRANT_DEFAULT_PROVIDER'] = 'virtualbox'


Vagrant.configure(VAGRANTFILE_API_VERSION) do |config|

  config.vm.box = "bento/centos-7"
  config.vm.boot_timeout = 120


  config.vm.define "zcolleenS" do |s|
    s.vm.provider "virtualbox" do |provider|
      provider.cpus = 1
      provider.memory = 512

      provider.customize ["modifyvm", :id, "--name", "zcolleenS", "--natdnsproxy1", "on", "--natdnshostresolver1", "on"]
    end

    s.vm.network :private_network, ip: "192.168.42.110"
    s.vm.provision "shell", inline: <<-SHELL
        curl -sfL https://get.k3s.io | sh -s - server \
        --write-kubeconfig-mode 0644 \
        --node-ip "192.168.42.110" \
        --node-name "zcolleenS"
        cat /var/lib/rancher/k3s/server/node-token > /var/lib/rancher/k3s/server/token_dir/token
      SHELL

      s.vm.synced_folder SHARED_HOST_FOLDER, "/var/lib/rancher/k3s/server/token_dir", create: true
  end


  config.vm.define "zcolleenSW" do |sw|

    sw.vm.provider "virtualbox" do |provider|
      provider.cpus = 1
      provider.memory = 512

      provider.customize ["modifyvm", :id, "--name", "zcolleenSW", "--natdnsproxy1", "on", "--natdnshostresolver1", "on"]
    end

    sw.vm.network :private_network, ip: "192.168.42.111"
    sw.vm.provision "shell", inline: <<-SHELL
        curl -sfL https://get.k3s.io | K3S_URL=https://192.168.42.110:6443 K3S_TOKEN=$(cat /var/lib/rancher/k3s/server/token_dir/token) \
        sh -s - agent \
        --node-ip "192.168.42.111" \
        --node-name "zcolleenSW"
      SHELL

    sw.vm.synced_folder SHARED_HOST_FOLDER, "/var/lib/rancher/k3s/server/token_dir", create: true
  end

end
