# Apache installation
class apache {

  $site_name = "root"
  $document_root = "root"

  package {
    'apache2':
      ensure => present
  }

  # define setup_apache($site_name, $document_root) {
  #   file {
  #     "create ${site_name} apache2 vhost":
  #       ensure  => file,
  #       path    => "/etc/apache2/sites-enabled/${site_name}.conf",
  #       content => template('/vagrant/puppet/modules/apache/templates/apache2-vhosts.conf.erb')
  #   }
  # }
}