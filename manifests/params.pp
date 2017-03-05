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
      $config_dir     = '/etc/loris2'
      $confdir     = '/etc/loris2'
      $default_vhost  = true
      $image_cache    = '/var/cache/loris2'
      $image_dir      = '/usr/local/share/images'
      $info_cache     = '/var/cache/loris2'
      $kdu_expand     = '/usr/local/bin/kdu_expand'
      $libkdu         = '/usr/local/lib'
      $log_dir        = '/var/log/loris2'
      $log_level      = 'INFO'
      $loris_group    = 'loris'
      $loris_owner    = 'loris'
      $loris_owner_home    = '/var/www/loris2'
      $loris_revision = 'v2.1.0-final'
      $server_name    = 'loris.local'
      $server_admin   = "root@${server_name}"
      $source_images  = '/usr/local/share/images'
      $tmp_dir        = '/tmp/loris2'
      $www_dir        = '/var/www/loris2'
      $user           = 'loris'
      $user_home      = "/var/www/${user}2"
    }
  }

}
