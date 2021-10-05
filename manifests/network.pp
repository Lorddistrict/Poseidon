# Network config - DNSmasq
class network {
  package {
    'dnsmasq':
      ensure => present,
      name   => 'dnsmasq'
  }
}

node s0 {
  include network
}