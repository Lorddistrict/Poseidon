# Apache & PHP installation
class apache_php {
  package {
    'apache2':
      ensure => present
  }
  package {
    'php7.3':
      ensure => present
    }

  service { 'apache2':
    ensure  => true,
    enable  => true,
    require => Package['apache2'],
  }

}

  # node s2.infra{
  #   include apache_php;
  # }
