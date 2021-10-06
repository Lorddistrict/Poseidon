# Network config - DNSmasq for s0.infra
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