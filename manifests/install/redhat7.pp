# == Class: loris
#
class loris::install::redhat7(
  #$image_dir = heira('loris::image_dir', $loris::params::image_dir), 
  #$user      = heira('loris::user', $loris::params::user), 
  $image_dir = $loris::params::image_dir,
  $user      = $loris::params::user,
  $user_home = $loris::params::user_home,

) inherits loris::params {

  # Make the loris user
  user { $user :
    ensure => present,
    home   => $user_home,
    shell  => '/bin/bash',
  }
  # Eventually loris will be dependent on apache
  # but for now lets make the directories
  file { '/var/www':
    ensure => directory,
  }
  file { $user_home:
    ensure => directory,
    owner  => $user,
    group  => $user,
    mode   => '0755',
  }
  file { $image_dir:
    ensure => directory,
    owner  => $user,
    group  => $user,
    mode   => '0755',
  }
  class { 'python':
    version    => 'system',
    pip        => 'present',
    dev        => 'present',
    virtualenv => 'present',
    gunicorn   => 'absent',
    use_epel   => true,
  }
  python::pip { 'pip':
    ensure     => latest,
    pkgname    => 'pip',
    virtualenv => 'system',
    owner      => 'root',
    timeout    => 1800,
  }
  python::pip { 'Werkzeug':
    ensure     => present,
    pkgname    => 'Werkzeug',
    virtualenv => 'system',
    owner      => 'root',
    timeout    => 1800,
  }
  python::pip { 'Pillow':
    ensure     => present,
    pkgname    => 'Pillow',
    virtualenv => 'system',
    owner      => 'root',
    timeout    => 1800,
  }
  #python::virtualenv { 'loris venv' :
  #  ensure     => present,
  #  version    => 'system',
  #  systempkgs => true,
  #  venv_dir   => "${user_home}/virtualenv",
  #  owner      => $user,
  #  group      => $user,
  #  cwd        => '/tmp/vtmp',
  #  timeout    => 0,
  #}
  #python::pip { 'Werkzeug for loris venv':
  #  ensure     => present,
  #  pkgname    => 'Werkzeug',
  #  virtualenv => "${user_home}/virtualenv",
  #  owner      => 'loris',
  #  timeout    => 1800,
  #}
  #python::pip { 'Pillow for loris venv':
  #  ensure     => present,
  #  pkgname    => 'Pillow',
  #  virtualenv => "${user_home}/virtualenv",
  #  owner      => 'loris',
  #  timeout    => 1800,
  #}
  file { "${user_home}/setup":
    ensure => directory,
    owner  => $user,
    group  => $user,
    mode   => '0755',
  }
  file { "${user_home}/setup/loris2":
    ensure => directory,
    owner  => $user,
    group  => $user,
    mode   => '0755',
  }
  vcsrepo { "${user_home}/setup/loris2" :
    ensure   => present,
    provider => git,
    source   => 'git://github.com/loris-imageserver/loris',
    revision => 'v2.1.0-final',
  }

  exec { 'loris setup' :
    path    => [ "${user_home}/virtualenv/bin", '/bin',
                '/usr/bin', '/usr/local/bin'],
    cwd     => "${user_home}/setup/loris2",
    #command => "${user_home}/virtualenv/bin/python setup.py install",
    command => "python setup.py install",
    creates => "${user_home}/loris2.wsgi",
    require => [ Class['apache'], Vcsrepo["${user_home}/setup/loris2"] ],
    notify  => File["${user_home}/loris2.wsgi"],
  }
  file { "${user_home}/loris2.wsgi" :
    ensure  => present,
    owner   => $user,
    group   => $user,
    mode    => '0755',
    content => template('loris/loris2.wsgi.erb'),
    require => Exec['loris setup'],
  }
  file { '/usr/local/bin/kdu_expand':
    ensure => file,
    source => "file:///${user_home}/setup/loris2/bin/Linux/x86_64/kdu_expand",
    owner  => 'root',
    group  => 'root',
    mode   => '0755',
    require => Exec['loris setup'],
  }
  file { '/usr/local/lib/libkdu_v74R.so':
    ensure => file,
    source => "file:///${user_home}/setup/loris2/lib/Linux/x86_64/libkdu_v74R.so",
    owner  => 'root',
    group  => 'root',
    mode   => '0755',
    require => Exec['loris setup'],
  }

}
