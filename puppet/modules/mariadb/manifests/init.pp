class maria::debpackages {

  package { 'mariadb-server':
    ensure => 'installed',
  }
  package { 'mariadb-client':
    ensure => 'installed',
  }

}
