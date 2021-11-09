module Vagrantconf

	NAME = "wquinoaS"
	IP = "192.168.42.110"

	PROVIDER = "virtualbox"	
	BOX = "generic/centos8"

	HOST_DIR = "./confs/shared"
	GUEST_DIR = "/hello_kubernetes"

	MEMORY = "2048"
	CPUS = "3"

	def self.createK3Sargs
		conf = YAML::load_file("#{HOST_DIR}/k3s_args.yaml")
		conf["node-ip"] = IP
		conf["node-name"] = NAME
		File.write("#{HOST_DIR}/k3s_args.yaml", conf.to_yaml)
	end

end
