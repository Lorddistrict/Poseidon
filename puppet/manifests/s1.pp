
node 's1'{
  $servername = 's1.infra'
  include apache
  include apache::vhosts
  include php
 }
