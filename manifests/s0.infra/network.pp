# Network config - DNSmasq for s0.infra
package {
  'dnsmasq':
    ensure => present,
    name   => 'dnsmasq'
}