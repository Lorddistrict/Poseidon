node 'control' {
  notify { 'this node did not match any of the listed definitions': }
}

node 's0' {
  include dnsmasq
}

node 's1' {
  include apache
  include php
}

node 's2' {
  include apache
  include php
}