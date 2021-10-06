node 's0' {
  include dnsmasq
  class { 'puppet':
    hostname => 's0'
  }
}

node 's1' {
  class { 'puppet':
    hostname => 's1'
  }
}

node 's2' {
  class { 'puppet':
    hostname => 's2'
  }
}

node 's3' {
  class { 'puppet':
    hostname => 's3'
  }
}

node 's4' {
  class { 'puppet':
    hostname => 's4'
  }
}