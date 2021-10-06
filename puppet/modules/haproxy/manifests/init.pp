class { 'haproxy':
  enable           => true,
  global_options   => {
    'log'     => "${::ipaddress} local0",
    'chroot'  => '/var/lib/haproxy',
    'pidfile' => '/var/run/haproxy.pid',
    'maxconn' => '4000',
    'user'    => 'haproxy',
    'group'   => 'haproxy',
    'daemon'  => '',
    'stats'   => 'socket /var/lib/haproxy/stats',
  },
  defaults_options => {
    'log'     => 'global',
    'stats'   => 'enable',
    'option'  => 'redispatch',
    'retries' => '3',
    'timeout' => [
      'http-request 10s',
      'queue 1m',
      'connect 10s',
      'client 1m',
      'server 1m',
      'check 10s',
    ],
    'maxconn' => '8000',
  },
}



# Declare a couple of Listening Services for haproxy.cfg
#  Note that the balancermember server resources are being collected in
#  the haproxy::config defined resource type with the following line:
#  Haproxy::Balancermember <<| listening_service == $name |>>
haproxy::listen { 's0.infra':
  order     => '20',
  ipaddress => $::ipaddress,
  ports     => '80',
  options   => {
    'option'  => [
      'tcplog',
    ],
    'balance' => 'roundrobin',
  }
}
haproxy::balancermember { 's1.infra':
    listening_service => 's0.infra',
    server_names      => 's1.infra',
    ipaddresses       => '192.168.50.10',
    ports             => '80',
    options           => 'check',
  }
  haproxy::balancermember { 's2.infra':
    listening_service => 's0.infra',
    server_names      => 's2.infra',
    ipaddresses       => '192.168.50.20',
    ports             => '80',
    options           => 'check',
  }
