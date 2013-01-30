Vagrant::Config.run do |config|
  config.vm.box = "lucid32"
  config.vm.forward_port 8080, 8080
  config.vm.forward_port 8000, 8000
  config.vm.customize ["modifyvm", :id, "--memory", 1024]
  config.vm.provision :puppet
end
