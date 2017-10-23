# == Class: loris
#
# Manage the loris image server
#
# === Parameters
#
# Document parameters here.
#
# === Variables
#
# === Examples
#
#  class { 'loris':
#  }
#
# === Authors
#
# Flannon Jackson <flannon@nyu.edu>
#
# === Copyright
#
# Copyright 2017 Your name here, unless otherwise noted.
#
class loris::demo(
  String $image_dir = lookup('loris::image_dir', String, 'first'),
  String $user      = lookup('loris::user', String, 'first'),
){
    file { "${image_dir}/001.jp2" :
      ensure  => file,
      owner   => $user,
      group   => $user,
      mode    => '0644',
      source  => 'puppet:///modules/loris/001.jp2',
      require => Class['loris::install'],
    }
}
