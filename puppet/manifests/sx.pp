
node 's1'{
  $servername = 's1.infra'
  include apache
  include apache::vhosts
  include php

  class { '::nfs':
      client_enabled => true,
    }
    Nfs::Client::Mount <<| |>> {
      ensure => 'mounted',
      mount  => '/mnt/nfs'
    }
 }

node 's2'{
  $servername = 's2.infra'
  include apache
  include apache::vhosts
  include php

  class { '::nfs':
      client_enabled => true,
    }
    Nfs::Client::Mount <<| |>> {
      ensure => 'mounted',
      mount  => '/mnt/nfs'
    }
}

node 's3'{
  include mariadb
}

node 's4'{
  include nfs
}
