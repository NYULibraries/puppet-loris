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
class loris::params {

  case $::osfamily {
    'RedHat' : {
      $default_vhost  = true
      $image_dir      = '/usr/local/share/images'
      $loris_revision = 'v2.1.0-final'
      $server_name    = 'loris.local'
      $server_admin   = "root@${server_name}"
      $user           = 'loris'
      $user_home      = "/var/www/${user}2"
    }
  }

}
