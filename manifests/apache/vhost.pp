# == Class: loris::apache::vhost
#
class loris::apache::vhost(
  #$image_dir = heira('loris::image_dir', $loris::params::image_dir), 
  #$user      = heira('loris::user', $loris::params::user), 
  String $default_vhost = lookup('loris::default_vhost', String, 'first'),
  String $image_dir     = lookup('loris::image_dir', String, 'first'),
  String $user          = lookup('loris::user', String, 'first'),
  String $user_home     = lookup('loris::user_home', String, 'first'),
  #$vhost_value   = lookup('loris::params::vhost_value', String, 'first'),
){
  
  if $default_vhost == true {
    $vhost_value = '10'
  }
  elsif $default_vhost == false {
    $vhost_value = '25'
  } 
  apache::vhost { 'loris-default':
    servername                  => $::fqdn,
    default_vhost               => $default_vhost,
    docroot                     => '/var/www/html',
    port                        => 80,
    #port                       => 443,
    ssl                         => false,
    allow_encoded_slashes       => 'on',
    headers                     => ['set Access-Control-Allow-Origin "*"', 'set Access-Control-Allow-Headers "x-pjax, x-requested-with"'],
    wsgi_daemon_process         => 'loris2',
    wsgi_daemon_process_options => {
      user                      => 'loris',
      group                     => 'loris',
      processes                 => '10',
      threads                   => '15',
      maximum-requests          => '10000',
    },
    wsgi_process_group  => 'loris2',
    wsgi_script_aliases => { '/loris' => '/var/www/loris2/loris2.wsgi'},

    directories        => [  
      { 'path'         => '/var/www/html/photo',
        allow_override => ['All'],
        options        => ['-Indexes', '+FollowSymlinks',],
      },
    ],
  }
  # The AllowsEncodedSlashes directive accepts values of 
  # On|Off|NoDecode, but the parameter allow_encoded_slashes only
  # accepts values of on|off|nodecode.  I left allow_encoded_slashes
  # enabled in Apache::Vhost['loris-defautl'] as a reminder for 
  # to get back to later.
  file_line { "${vhost_value}-loris-default.conf AllowEncodedSlashes":
    ensure  => present,
    path    => "/etc/httpd/conf.d/${vhost_value}-loris-default.conf",
    line    => '  AllowEncodedSlashes On',
    match   => '^\ \ AllowEncodedSlashes on',
    require => Apache::Vhost['loris-default'],
  }
  # ExpiresDefault can be declared in the vhost definition
  # but this is not currently supported in apache::vhost
  file_line { "${vhost_value}-loris-default.conf ExpiresDefault":
    ensure  => present,
    path    => "/etc/httpd/conf.d/${vhost_value}-loris-default.conf",
    after   => '^\ \ AllowEncodedSlashes\ On',
    line    => '  ExpiresActive On',
    require => Apache::Vhost['loris-default'],
  }
  # ExpiresActive can be declared in the vhost definition
  # but this is not currently supported in apache::vhost
  file_line { "${vhost_value}-loris-default.conf ExpiresActive":
    ensure  => present,
    path    => "/etc/httpd/conf.d/${vhost_value}-loris-default.conf",
    after   => '^\ \ ExpiresActive\ On',
    line    => '  ExpiresDefault "access plus 5184000 seconds"',
    require => Apache::Vhost['loris-default'],
  }
}
