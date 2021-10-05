class { '::nfs':
  server_enabled => true,
}
nfs::server::export { '/home/data':
  ensure  => 'mounted',
  clients => '192.168.50.40/24(rw,insecure,async,no_root_squash) localhost(rw)',
}
