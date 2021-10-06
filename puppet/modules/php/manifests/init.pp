# PHP installation
class php {
  package { 'php7.3':
    ensure => present,
    name   => 'php7.3'
  }
  service { 'php7.3':
    ensure => running
  }
}