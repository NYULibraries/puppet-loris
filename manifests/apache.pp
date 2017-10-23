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
  String $default_vhost  = lookup('loris::default_vhost', String, 'first'),
  String $image_dir      = lookup('loris::image_dir', String, 'first'),
  String $loris_revision = lookup('loris::loris_revision', String, 'first'),
  String $server_admin   = lookup('loris::server_admin', String, 'first'),
  String $server_name    = lookup('loris::server_name', String, 'first'),
  String $user           = lookup('loris::user', String, 'first'),
  String $user_home      = lookup('loris::user_home', String, 'first'),
){
  # Drop mod_expires for the default_mods array
  #$default_mods = [ 'actions', 'authn_core', 'cache', 'ext_filter',
  #                  'mime', 'mime_magic', 'rewrite', 'speling',
  #                  'suexec', 'version', 'vhost_alias', 'auth_digest',
  #                  'authn_anon', 'authn_dbm', 'authz_dbm', 
  #                  'authz_owner', 'include', 'logio', 'substitute',
  #                  'usertrack',
  #]

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
  #class { 'apache::mod::expires' :
  #  #expires_default => ['access', 'plus', '5184000', 'seconds',],
  #  #expires_default => 'access plus 5184000 seconds',
  #}
  #include apache::mod::expires

  # I still need to figure out how to define 
  # apache::mod:: expires parameters
  #include apache::mod::expires

  firewall { '100 allow http and https access':
    dport  => [ 80, 443, 8080, 9080 ],
    #dport  => [ 80, 443, 8080 ],
    proto  => tcp,
    action => accept,
  }
}
