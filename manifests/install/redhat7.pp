# == Class: loris
#
class loris::install::redhat7(
  #$image_dir = heira('loris::image_dir', $loris::params::image_dir), 
  #$user      = heira('loris::user', $loris::params::user), 
  $image_dir = $loris::params::image_dir,
  $user      = $loris::params::user,
  $user_home = $loris::params::user_home,

) inherits loris::params {

  notice('notice from loris::install::redhat7  ----------')
  notice('this is a test to see if vagrant provisioning is still super slow  ----------')

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
  python::virtualenv { 'loris venv' :
    ensure     => present,
    version    => 'system',
    systempkgs => true,
    venv_dir   => "${user_home}/virtualenv",
    owner      => $user,
    group      => $user,
    cwd        => '/tmp/vtmp',
    timeout    => 0,
  }
  python::pip { 'Werkzeug for loris venv':
    ensure     => present,
    pkgname    => 'Werkzeug',
    virtualenv => "${user_home}/virtualenv",
    owner      => 'loris',
    timeout    => 1800,
  }
  python::pip { 'Pillow for loris venv':
    ensure     => present,
    pkgname    => 'Pillow',
    virtualenv => "${user_home}/virtualenv",
    owner      => 'loris',
    timeout    => 1800,
  }
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
    path    => [ '/bin', '/usr/bin', '/usr/local/bin'],
    cwd     => "${user_home}/setup/loris2",
    command => "python setup.py install",
    creates => "${user_home}/setup/.loris-installed",
    require => [ Class['apache'], Vcsrepo["${user_home}/setup/loris2"] ],
    notify  => File["${user_home}/setup/.loris-installed"],
  }
  file { "${user_home}/setup/.loris-installed" :
    ensure => present,
    owner  => $user,
    group  => $user,
    mode   => '0755',
  }

  #exec { 'loris setup' :
  #  path  => [ "${user_home}//virtualenv/bin", '/bin',
  #              '/usr/bin', '/usr/local/bin'],
  #  cwd     => "${user_home}/setup",
  #  command => "${user_home}/virtualenv/bin/python setup.py install",
  #  creates => "${user_home}/setup/.loris-installed",
  #  notify  => File["${user_home}/setup/.loris-installed"],
  #}
  #file { "${user_home}/setup/.loris-installed" :
  #  ensure => present,
  #  owner  => $user,
  #  group  => $user,
  #  mode   => '0755',
  #}


}
