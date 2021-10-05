
node 's1'{
  $servername = 's1.infra'
  include apache
  include apache::vhosts
  include php
 }

node 's2'{
  $servername = 's2.infra'
  include apache
  include apache::vhosts
  include php  
}

node 's3'{
  include mariadb
}

node 's4'{
  include nfs
}
