Vagrant::Config.run do |config|
  config.vm.box = "lucid32"
  config.vm.forward_port 8080, 8080
  config.vm.provision :puppet
  config.vm.provision :shell, :path => "liferay.sh"
end
