# -*- mode: ruby -*-
# vi: set ft=ruby sw=2 st=2 et :
# frozen_string_literal: true

SERVERS_COUNT = 5

Vagrant.configure('2') do |config|
    config.vm.box = 'debian/buster64'
    config.vm.box_check_update = false

    config.vm.provider 'virtualbox' do |vb|
        vb.memory = '2000'
        vb.cpus = 2
        vb.gui = false
    end

    # s0.infra machine (x1)
    config.vm.define 's0.infra' do |machine|
        machine.vm.hostname = 's0.infra'
        machine.vm.network 'private_network', ip: '192.168.50.250'
    end

    # sX.infra machines (x5)
    SERVERS_COUNT.times do |index|
        config.vm.define "s#{index + 1}.infra" do |machine|
            machine.vm.hostname = "s#{index + 1}.infra"
            machine.vm.network 'private_network', ip: "192.168.50.#{index * 10 + 10}"
        end
    end

    config.vm.provision 'shell', path: 'provision.sh'

end