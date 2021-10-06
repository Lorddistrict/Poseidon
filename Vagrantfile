# -*- mode: ruby -*-
# vi: set ft=ruby sw=2 st=2 et :
# frozen_string_literal: true

SERVERS_COUNT = 3

Vagrant.configure('2') do |config|
    config.vm.box = 'debian/buster64'
    config.vm.box_check_update = false

    config.vm.provider 'virtualbox' do |vb|
        vb.memory = '2000'
        vb.cpus = 2
        vb.gui = false
    end

    # s0.infra machine (x1)
    config.vm.define 'control' do |machine|
        machine.vm.hostname = 'control'
        machine.vm.network 'private_network', ip: '192.168.50.250', name: 'vboxnet0'
    end

    # sX.infra machines (x5)
    SERVERS_COUNT.times do |index|
        config.vm.define "s#{index}.infra" do |machine|
            machine.vm.hostname = "s#{index}.infra"
            machine.vm.network 'private_network', ip: "192.168.50.#{index * 10 + 10}", name: 'vboxnet0'

            if index = 1
                machine.vm.network "forwarded_port", guest: 80, host: 1010
            end

            if index = 2
                machine.vm.network "forwarded_port", guest: 80, host: 2020
            end

        end
    end

    config.vm.provision 'shell', path: 'provision.sh'
end