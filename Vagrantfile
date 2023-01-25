Vagrant.configure("2") do |config|
    config.vm.box = "generic/rhel8"
    config.vm.provider "virtualbox" do |v|
        v.gui = false
        v.name = 'microshift-starter'
        # provides 3GB of memory
        v.memory = 3072
        # for parallelization
        v.cpus = 2
    end
    
    # NAME THE VM SO WE CAN IDENTIFY IT
    config.vm.define 'microshift-starter'
    config.vm.hostname = 'microshift-starter.local'

    # NETWORKING
    config.vm.network :forwarded_port, guest: 30036, host: 30036, id: "console"
    config.vm.network :forwarded_port, guest: 80, host: 80, id: "web"
    config.vm.network :forwarded_port, guest: 443, host: 443, id: "tls"
    config.vm.network :forwarded_port, guest: 6443, host: 6443, id: "api"
  
    # SHARED HOST FOLDER
    config.vm.synced_folder "~/Downloads", "/vagrant_data"

    # RHSM using the vagrant-registration plugin
    if Vagrant.has_plugin?('vagrant-registration')
        config.registration.username = ENV['SUB_USERNAME']
        config.registration.password = ENV['SUB_PASSWORD']
        #config.registration.pools = ['pool1', 'pool2']
        config.registration.unregister_on_halt = false
    end

    config.vm.provision "shell",
        path: "provision.sh"
end