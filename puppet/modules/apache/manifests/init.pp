# Apache & PHP installation
class apache (
  $apachename   = $::apache::params::apachename,
) inherits ::apache::params {
  package {
    'apache2':
      name => $apachename,
      ensure => present,
  }

}

file { 'configuration-file':
  path    => $conffile,
  ensure  => file,
  source  => $confsource,
  notify  => Service['apache-service'],
}

service { 'apache-service':
  name          => $apachename,
  hasrestart    => true,
}
