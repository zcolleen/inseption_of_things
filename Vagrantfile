# -*- mode: ruby -*-
# vi: set ft=ruby :

# All Vagrant configuration is done below. The "2" in Vagrant.configure
# configures the configuration version (we support older styles for
# backwards compatibility). Please don't change it unless you know what
# you're doing.

# K1003a5e062ad055d12d65c2c984d3df3825ff41305a272dcfe8d6cdfad39c3efd6::server:b70b8c9b13b7abcf07eb1dec50c62e19


VAGRANTFILE_API_VERSION = "2"

ENV['VAGRANT_DEFAULT_PROVIDER'] = 'virtualbox'

Vagrant.configure(VAGRANTFILE_API_VERSION) do |config|
  # The most common configuration options are documented and commented below.
  # For a complete reference, please see the online documentation at
  # https://docs.vagrantup.com.

  # Every Vagrant development environment requires a box. You can search for
  # boxes at https://vagrantcloud.com/search.
  config.vm.box = "bento/centos-7"
  config.vm.boot_timeout = 120
  # config.vm.provider "virtualbox" do |provider|
  #   provider.cpus = 1
  #   provider.memory = 512
  #   # provider.has_ssh = true
  #   # provider.create_args = [ "--privileged", "-v", "/sys/fs/cgroup:/sys/fs/cgroup:ro" ]

  # end


  config.vm.define "zcolleenS" do |s|
    s.vm.provider "virtualbox" do |provider|
      provider.cpus = 1
      provider.memory = 512

      provider.customize ["modifyvm", :id, "--name", "zcolleenS", "--natdnsproxy1", "on", "--natdnshostresolver1", "on"]
    end

    s.vm.provision "shell", inline: <<-SHELL
        curl -sfL https://get.k3s.io | sh
        token = cat /var/lib/rancher/k3s/server/node-token
      SHELL
    s.vm.network :private_network, ip: "192.168.42.110"
  end

  config.vm.define "zcolleenSW" do |sw|

    sw.vm.provider "virtualbox" do |provider|
      provider.cpus = 1
      provider.memory = 512

      provider.customize ["modifyvm", :id, "--name", "zcolleenSW", "--natdnsproxy1", "on", "--natdnshostresolver1", "on"]
    end

    sw.vm.network :private_network, ip: "192.168.42.111"
    sw.vm.provision "shell", inline: <<-SHELL
    curl -sfL https://get.k3s.io | K3S_URL=https://192.168.42.110:6443 K3S_TOKEN=mynodetoken sh -
      SHELL
  end

  # Disable automatic box update checking. If you disable this, then
  # boxes will only be checked for updates when the user runs
  # `vagrant box outdated`. This is not recommended.
  # config.vm.box_check_update = false

  # Create a forwarded port mapping which allows access to a specific port
  # within the machine from a port on the host machine. In the example below,
  # accessing "localhost:8080" will access port 80 on the guest machine.
  # NOTE: This will enable public access to the opened port
  # config.vm.network "forwarded_port", guest: 80, host: 8080

  # Create a forwarded port mapping which allows access to a specific port
  # within the machine from a port on the host machine and only allow access
  # via 127.0.0.1 to disable public access
  # config.vm.network "forwarded_port", guest: 80, host: 8080, host_ip: "127.0.0.1"

  # Create a private network, which allows host-only access to the machine
  # using a specific IP.
  # config.vm.network "private_network", ip: "192.168.33.10"

  # Create a public network, which generally matched to bridged network.
  # Bridged networks make the machine appear as another physical device on
  # your network.
  # config.vm.network "public_network"

  # Share an additional folder to the guest VM. The first argument is
  # the path on the host to the actual folder. The second argument is
  # the path on the guest to mount the folder. And the optional third
  # argument is a set of non-required options.
  # config.vm.synced_folder "../data", "/vagrant_data"

  # Provider-specific configuration so you can fine-tune various
  # backing providers for Vagrant. These expose provider-specific options.
  # Example for VirtualBox:
  #
  # config.vm.provider "virtualbox" do |vb|
  #   # Display the VirtualBox GUI when booting the machine
  #   vb.gui = true
  #
  #   # Customize the amount of memory on the VM:
  #   vb.memory = "1024"
  # end
  #
  # View the documentation for the provider you are using for more
  # information on available options.

  # Enable provisioning with a shell script. Additional provisioners such as
  # Ansible, Chef, Docker, Puppet and Salt are also available. Please see the
  # documentation for more information about their specific syntax and use.
  # config.vm.provision "shell", inline: <<-SHELL
  #   apt-get update
  #   apt-get install -y apache2
  # SHELL
end
