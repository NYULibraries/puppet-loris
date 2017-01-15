# == Class: loris
#
# == Class: profiles::img_loris
#
# Full description of class profile here.
#
#
# === Authors
#
# Flannon Jackson <flannon@nyu.edu>
#
# === Copyright
#
# Copyright 2016 Your NYULibraries, unless otherwise noted.
#
class loris::apache(
  #$image_dir = heira('loris::image_dir', $loris::params::image_dir), 
  #$user      = heira('loris::user', $loris::params::user), 
  $image_dir    = $loris::params::image_dir,
  $loris_revision = $loris::params::loris_revision,
  $server_admin = $loris::params::server_admin,
  $server_name  = $loris::params::server_name,
  $user         = $loris::params::user,
  $user_home    = $loris::params::user_home,
) inherits loris::params {

  # install apache
  class { 'apache' :
    package_ensure         => present,
    service_enable         => true,
    default_mods           => true,
    default_vhost          => false,
    dev_packages           => 'httpd-devel',
    docroot                => '/var/www/html',
    httpd_dir              => '/etc/httpd',
    keepalive              => 'On',
    keepalive_timeout      => '2',
    max_keepalive_requests => '500',
    lib_path               => 'modules',
    log_level              => 'warn',
    logroot                => '/var/log/httpd',
    mod_dir                => '/etc/httpd/conf.d',
    mpm_module             => 'prefork',
    pidfile                => 'run/httpd.pid',
    sendfile               => 'On',
    serveradmin            => $server_admin,
    servername             => $server_name,
    server_root            => '/etc/httpd',
    service_name           => 'httpd',
    service_manage         => true,
    timeout                => '120',
    file_mode              => '0644',
    vhost_dir              => '/etc/httpd/conf.d',
    vhost_include_pattern  => '[^.#].conf[^~]',
    user                   => 'apache',
    apache_name            => 'httpd',
  }

  include apache::dev
  include apache::mod::deflate
  include apache::mod::info
  include apache::mod::php
  include apache::mod::rewrite
  include apache::mod::headers
  #include apache::mod::wsgi
  class { 'apache::mod::wsgi' :
    wsgi_python_home => "${user_home}/virtualenv",
  }

  # I still need to figure out how to define 
  # apache::mod:: expires parameters
  #include apache::mod::expires

  firewall { '100 allow http and https access':
    dport  => [ 80, 8080, 9080 ],
    proto  => tcp,
    action => accept,
  }

}
