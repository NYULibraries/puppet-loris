# == Class: loris::apache::vhost
#
class loris::apache::vhost(
  #$image_dir = heira('loris::image_dir', $loris::params::image_dir), 
  #$user      = heira('loris::user', $loris::params::user), 
  $image_dir = $loris::params::image_dir,
  $user      = $loris::params::user,
  $user_home = $loris::params::user_home,

) inherits loris::params {
  
  apache::vhost { 'loris-default':
    servername                  => 'default',
    docroot                     => '/var/www/html',
    port                        => 80,
    #port                       => 443,
    ssl                         => false,
    ##
    # I still need to figure out how to set expires_default
    ##
    #expires_default => 'access plus 5184000 seconds',
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
  # This is a bit of a hack, but I'm confused as to what
  # puppetlabs-apache appache::mod::epire is doing and how to 
  # override it's parameters
  file_line { '25-loris-default.conf ExpiresDefault':
    ensure  => present,
    path    => '/etc/httpd/conf.d/25-loris-default.conf',
    after   => '^\ \ AllowEncodedSlashes\ on',
    line    => '  ExpiresActive On',
    require => Apache::Vhost['loris-default'],
  }
  file_line { '25-loris-default.conf ExpiresActive':
    ensure  => present,
    path    => '/etc/httpd/conf.d/25-loris-default.conf',
    after   => '^\ \ ExpiresActive\ On',
    line    => '  ExpiresDefault "access plus 5184000 seconds"',
    require => Apache::Vhost['loris-default'],
  }
}
