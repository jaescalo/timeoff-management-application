# -*- mode: ruby -*-
# vi: set ft=ruby :

Vagrant.configure("2") do |config|
  # Use Ubuntu 20.10 to build the VM
  config.vm.box = "bento/ubuntu-20.10"
  # Use local Ubuntu box to build the VM
  config.vm.box_url = "/Users/jaescalo/Google Drive/DevOps/Tools/ubuntu2010.box"
  # Naming the VM
  config.vm.hostname = "toma"

  config.vm.define "timeoff-application" do |timeoff|
    # Forwrd port 3000 which is used by the timeoff app
    timeoff.vm.network "forwarded_port", guest: 3000, host: 3001

    # Provision the app and requirements with Ansible
    timeoff.vm.provision "ansible" do |ansible|
      ansible.playbook="playbook.yaml"
    end
  end
end