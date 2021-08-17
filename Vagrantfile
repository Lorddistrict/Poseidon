# -*- mode: ruby -*-
# vi: set ft=ruby sw=2 st=2 et :
# frozen_string_literal: true

SERVERS_COUNT = 6

Vagrant.configure('2') do |config|
    config.vm.box = 'debian/buster64'
    config.vm.box_check_update = false

    config.vm.provider 'virtualbox' do |vb|
        vb.memory = '2000'
        vb.cpus = 2
        vb.gui = false
    end

    # Master machine
    config.vm.define 'master' do |machine|
        machine.vm.hostname = 'master'
        machine.vm.network 'private_network', ip: '192.168.50.250'
    end

    # Slave machines
    SERVERS_COUNT.times do |index|
        config.vm.define "slave#{index}" do |machine|
            machine.vm.hostname = "slave#{index}"
            machine.vm.network 'private_network', ip: "192.168.50.#{index * 10 + 10}"
            if index.zero?
                machine.vm.network 'forwarded_port', guest: 80, host: 1080
                machine.vm.network 'forwarded_port', guest: 8080, host: 8080
            end
        end
    end

    config.vm.provision 'shell', path: 'provision.sh'

end