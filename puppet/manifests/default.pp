class apache {
  package { 'apache2':
    ensure => present,
    name   => 'apache2'
  }
  service { 'apache2':
    ensure => running
  }
}

class dnsmasq {
  package {
    'dnsmasq':
      ensure => present
  }
  file {
    'add new dnsmasq.conf':
      ensure  => present,
      path    => '/etc/dnsmasq.conf',
      source  => '/vagrant/puppet/modules/dnsmasq/files/dnsmasq.conf',
      replace => true
  }
}

class php {
  package { 'php7.3':
    ensure => present,
    name   => 'php7.3'
  }
  service { 'php7.3':
    ensure => running
  }
}

node default {
  # do nothing
}

node 's0' {
  include dnsmasq
}

node 's1' {
  include apache
  include php
}

node 's2' {
  include apache
  include php
}