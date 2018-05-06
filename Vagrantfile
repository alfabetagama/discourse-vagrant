# -*- mode: ruby -*-
# vi: set ft=ruby :

# All Vagrant configuration is done below. The "2" in Vagrant.configure
# configures the configuration version (we support older styles for
# backwards compatibility). Please don't change it unless you know what
# you're doing.
if Vagrant::Util::Platform.windows? then
    required_plugins = ['vagrant-vbguest', 'vagrant-winnfsd' ]
else
    required_plugins = ['vagrant-vbguest']
end

required_plugins.each_with_index do |plugin, index|
	if !Vagrant.has_plugin? plugin then
        if system "vagrant plugin install #{plugin}"
            exec "vagrant #{ARGV.join(' ')}"
        else
            abort "Installation of one or more plugins has failed. Aborting."
        end
	end
end

Vagrant.configure(2) do |config|
  config.vm.box = "bento/ubuntu-16.04"
  # config.vm.box_check_update = false
  config.vm.network "forwarded_port", guest: 3000, host: 3000
  config.vm.network "forwarded_port", guest: 1080, host: 1080
  config.vm.network "forwarded_port", guest: 5432, host: 5432
  config.vm.network "forwarded_port", guest: 1234, host: 7000, auto_correct: true
  # Create a private network, which allows host-only access to the machine
  # using a specific IP.
  config.vm.network "private_network", ip: "192.168.33.10"
  config.vm.network "public_network"
  # smbfs share is slow
  # config.vm.synced_folder "apps/", "/home/vagrant/apps", type: "smb", :mount_options => ["file_mode=0777", #"dir_mode=0777", "mfsymlinks", "noperm"]
  
  # disable default share
  config.vm.synced_folder '.', '/vagrant', disabled: true
  
  #setup nfs share
  config.vm.synced_folder "apps/", "/home/vagrant/apps", type: "nfs", mount_options:['nolock,noatime']
  
  config.ssh.forward_agent = true
  config.vm.provider "virtualbox" do |vb|
    vb.gui = true
    vb.name = "discourse" + Time.now.strftime("%Y-%d-%m-%H-%M-%S")
    vb.memory = "3000"
    vb.cpus = 2
    # to make symlinks in shared folder work we need to run vagrant up in 
    # console with admin privileges on windows :(
    vb.customize ["setextradata", :id, 
    "VBoxInternal2/SharedFoldersEnableSymlinksCreate/home_vagrant_apps", "1"]
    vb.customize ["modifyvm", :id, "--cableconnected1", "on"]
	vb.customize ["modifyvm", :id, "--cableconnected2", "on"]
	vb.customize ["modifyvm", :id, "--cableconnected3", "on"]
  end
  config.vm.provision :shell, :path => "swapfile.sh"
  config.vm.provision :shell, :path => "bootstrap.sh", :privileged =>false
end
