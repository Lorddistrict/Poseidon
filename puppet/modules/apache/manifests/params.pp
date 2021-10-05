class apache::params {

  if $::osfamily == 'Debian' {
    $apachename = 'apache2'
    $conffile     = '/etc/apache2/apache2.conf'
    $confsource   = 'puppet:///modules/apache/apache2.conf'
  } else {
    print "This is not a supported distro."
  }

}
