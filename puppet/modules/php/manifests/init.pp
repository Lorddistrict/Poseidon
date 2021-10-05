# Apache & PHP installation
class php {
  package {
    'php7.4':
      name => 'php'
      ensure => present
    }

    service { 'php-service':
    name    => 'php',
    ensure  => running,
    enable  => true,
  }
}
