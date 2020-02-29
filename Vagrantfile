Vagrant.configure("2") do |config|
    config.vm.box = "generic/ubuntu1804"
    config.vm.provider "hyperv"
    config.vm.network "public_network"
    config.vm.provision "file", source: "./kit", destination: "~/."
    config.vm.provision "shell", inline: "chmod +x bootstrap-internetconnected.sh"
    config.vm.provision "shell", inline: "sudo ./bootstrap-internetconnected.sh"
end
