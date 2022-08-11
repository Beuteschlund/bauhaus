#!/usr/bin/bash

[[ ! -e Vagrantfile ]] && touch Vagrantfile
cat > Vagrantfile << EOF
# -*- mode: ruby -*-
# vi: set ft=ruby :

VAGRANTFILE_API_VERSION = "2"
ENV["LC_ALL"] = "en_US.UTF-8"

# DELETE OR ADD FURTHER ENTRIES DOWN BELOW
# AND CHANGE IPs & HOSTNAMES, IF NEEDED
boxes = [
    {
        :name => "proxy01-local",
        :cpus => "2",
        :memory => "2048",
        :address => "192.168.56.10",
        :distribution => "debian/bullseye64"
    },
    {
        :name => "web01-local",
        :cpus => "1",
        :memory => "2048",
        :address => "192.168.56.11",
        :distribution => "debian/bullseye64"
    },
    {
        :name => "db01-local",
        :cpus => "1",
        :memory => "2048",
        :address => "192.168.56.12",
        :distribution => "debian/bullseye64"
    },
    {
        :name => "cache01-local",
        :cpus => "1",
        :memory => "2048",
        :address => "192.168.56.13",
        :distribution => "debian/bullseye64"
    },
    {
        :name => "queue01-local",
        :cpus => "1",
        :memory => "2048",
        :address => "192.168.56.14",
        :distribution => "debian/bullseye64"
    }
]

Vagrant.configure(VAGRANTFILE_API_VERSION) do |config|
  boxes.each do |vars|
    config.vm.define vars[:name] do |machine|
      machine.vm.box = vars[:distribution]
      machine.ssh.forward_agent = true
      #machine.ssh.insert_key = false
      machine.vm.hostname = vars[:name]
      machine.vm.provider :virtualbox do |vb|
        vb.customize ["modifyvm", :id, "--memory", vars[:memory]]
        vb.customize ["modifyvm", :id, "--cpus", vars[:cpus]]
        vb.customize ["modifyvm", :id, "--ioapic", "on"]
        vb.customize ["modifyvm", :id, "--natdnsproxy1", "on"]
      end
      machine.vm.network :private_network, ip: vars[:address]
      machine.vm.provision "file", source: "~/.ssh/id_rsa.pub", destination: "~/host.pub"
      machine.vm.provision "shell", path: "./installCertificates.sh"
    end
  end
end
EOF

exit 0;