# == Class: loris
#
class loris::install::redhat7(
  $confdir          = hiera('loris::confdir', $loris::params::confdir),
  $default_vhost    = hiera('loris::default_vhost', $loris::params::default_vhost),
  $image_cache      = hiera('loris::image_cache', $loris::params::image_cache),
  $image_dir        = $loris::params::image_dir,
  $info_cache       = hiera('loris::info_cache', $loris::params::info_cache),
  $kdu_expand       = hiera('loris::kdu_expand', $loris::params::kdu_expand),
  $libkdu           = hiera('loris::libkdu', $loris::params::libkdu),
  $log_dir          = hiera('loris::log_dir', $loris::params::log_dir),
  $log_level        = hiera('loris::log_level', $loris::params::log_level),
  $loris_group      = hiera('loris::loris_group', $loris::params::loris_group),
  $loris_owner      = hiera('loris::loris_ownder', $loris::params::loris_owner),
  $loris_owner_home = hiera('loris::loris_owner_home', $loris::params::loris_owner_home),
  $loris_revision   = hiera('loris::loris_revision', $loris::params::loris_revision),
  $server_name      = hiera('loris::server_name', $loris::params::server_name),
  $server_admin     = hiera('loris::server_admin', $loris::params::server_admin),
  $source_images    = hiera('loris::source_image', $loris::params::source_images),
  $tmp_dir          = hiera('loris::tmp_dir', $loris::params::tmp_dir),
  $www_dir          = hiera('loris::www_dir', $loris::params::www_dir),
  $user             = $loris::params::user,
  $user_home        = $loris::params::user_home,

) inherits loris::params {

  # Make the loris user
  user { $loris_owner :
    ensure => present,
    home   => $loris_owner_home,
    shell  => '/bin/bash',
  }
  # Eventually loris will be dependent on apache
  # but for now lets make the directories
  file { '/var/www':
    ensure => directory,
  }
  file { $www_dir:
    ensure => directory,
    owner  => $user,
    group  => $user,
    mode   => '0755',
  }
  file { $source_images:
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
  python::pip { 'setuptools':
    ensure     => latest,
    pkgname     => 'setuptools',
    virtualenv => 'system',
    owner      => 'root',
    timeout    => 1800,
  }
  python::pip { 'virtualenv':
    ensure     => latest,
    pkgname     => 'virtualenv',
    virtualenv => 'system',
    owner      => 'root',
    timeout    => 1800,
  }

  python::virtualenv { "${www_dir}/virtualenv" :
    ensure     => present,
    version    => 'system',
    systempkgs => true,
    #distribute => false,
    venv_dir   => "${www_dir}/virtualenv",
    owner      => $loris_owner,
    group      => $loris_group,
    timeout    => 0,
    require    => Package['python-virtualenv.noarch'],
  }
  python::pip { "${www_dir}/virtualenv Werkzeug":
    ensure     => present,
    pkgname    => 'Werkzeug',
    virtualenv => "${www_dir}/virtualenv",
    owner      => 'loris',
    #owner      => 'root',
    timeout    => 1800,
  }
  python::pip { "${www_dir}/virtualenv Pillow":
    ensure     => present,
    pkgname    => 'Pillow',
    virtualenv => "${www_dir}/virtualenv",
    owner      => $loris_owner,
    timeout    => 1800,
  }
  file { "${www_dir}/src":
    ensure => directory,
    owner  => $loris_owner,
    group  => $loris_group,
    mode   => '0755',
  }
  file { "${www_dir}/src/loris2":
    ensure => directory,
    owner  => $loris_owner,
    group  => $loris_group,
    mode   => '0755',
  }
  vcsrepo { "${www_dir}/src/loris2" :
    ensure   => present,
    provider => git,
    source   => 'git://github.com/loris-imageserver/loris',
    revision => 'v2.1.0-final',
  }

  exec { 'exec_loris_setup' :
    path    => [ '/bin','/usr/bin', '/usr/local/bin', 
                "${www_dir}/virtualenv/bin"],
    #path    => [ '/bin', '/usr/bin', '/usr/local/bin'],
    cwd     => "${www_dir}/src/loris2",
    command => "${www_dir}/virtualenv/bin/python setup.py install --source-images $source_images --image-cache $image_cache",
    #command => "python setup.py install",
    creates => "${www_dir}/loris2.wsgi",
    require => [ Class['apache'], Vcsrepo["${www_dir}/src/loris2"],
                 Python::Virtualenv[ "${www_dir}/virtualenv"] ], 
    notify    => File["${www_dir}/loris2.wsgi"],
    tries     => '5',
    try_sleep => '1',
    user      => 'root',
  }
  file { "${www_dir}/loris2.wsgi" :
    ensure  => present,
    owner   => $loris_owner,
    group   => $loris_group,
    mode    => '0755',
    content => template('loris/loris2.wsgi.erb'),
    require => Exec['exec_loris_setup'],
  }
  file { $kdu_expand:
    ensure => file,
    source => "file:///${www_dir}/src/loris2/bin/Linux/x86_64/kdu_expand",
    owner  => 'root',
    group  => 'root',
    mode   => '0755',
    require => Exec['exec_loris_setup'],
  }
  file { "${libkdu}/libkdu_v74R.so":
    ensure => file,
    source => "file:///${www_dir}/src/loris2/lib/Linux/x86_64/libkdu_v74R.so",
    owner  => 'root',
    group  => 'root',
    mode   => '0755',
    require => Exec['exec_loris_setup'],
  }

  file { "${config_dir}/loris2.conf" :
    ensure  => present,
    owner   => $loris_owner,
    group   => $loris_group,
    mode    => '0755',
    content => template('loris/loris2.conf.erb'),
    require => Exec['exec_loris_setup'],
  }

}
