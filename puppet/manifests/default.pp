node default {
  # Something here
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