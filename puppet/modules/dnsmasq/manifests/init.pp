# Network config - DNSmasq for s0.infra
class dnsmasq {
  package {
    'dnsmasq':
      ensure => present
  }
}