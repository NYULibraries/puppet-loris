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
class loris(
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
  $source_images    = hiera('loris::source_images', $loris::params::source_images),
  $tmp_dir          = hiera('loris::tmp_dir', $loris::params::tmp_dir),
  $www_dir          = hiera('loris::www_dir', $loris::params::www_dir),

) inherits loris::params {

  include loris::dependencies
  include loris::install
  include loris::apache
  include loris::apache::vhost
  include loris::cache
  include loris::demo

}
