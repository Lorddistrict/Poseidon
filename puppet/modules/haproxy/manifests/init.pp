# Declare a couple of Listening Services for haproxy.cfg
#  Note that the balancermember server resources are being collected in
#  the haproxy::config defined resource type with the following line:
#  Haproxy::Balancermember <<| listening_service == $name |>>
haproxy::listen { 's1.infra':
  order     => '20',
  ipaddress => $::ipaddress,
  ports     => '80',
  options   => {
    'option'  => [
      'tcplog',
    ],
    'balance' => 'roundrobin',
  },
}
