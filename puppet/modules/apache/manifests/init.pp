# Apache installation
class apache {
  package { 'apache2':
    ensure => present,
    name   => 'apache2'
  }
  service { 'apache2':
    ensure => running
  }
}