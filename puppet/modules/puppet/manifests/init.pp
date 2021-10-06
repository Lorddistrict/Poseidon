# Setup puppet config
class puppet ($hostname) {

  file { '/etc/puppet/puppet.conf':
    ensure  => present,
    path    => '/etc/puppet/puppet.conf',
    content => template('/vagrant/puppet/modules/puppet/files/puppet.erb'),
    replace => true
  }

  exec {
    'systemctl restart puppet':
      command => 'systemctl restart puppet',
      path    => ['/usr/bin', '/bin', '/usr/sbin'],
      require => File['/etc/puppet/puppet.conf']
  }

  exec {
    'puppet agent --test':
      command => 'puppet agent --test',
      path    => ['/usr/bin', '/bin', '/usr/sbin'],
      require => File['/etc/puppet/puppet.conf']
  }
}