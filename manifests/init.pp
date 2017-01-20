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
  $default_vhost = $loris::params::default_vhost,
) inherits loris::params {

  #if $default_vhost == true {
  #  $vhost_value = '10'
  #}
  #elsif $default_vhost == false {
  #  #else {
  #  $vhost_value = '25'
  #} 
  include loris::dependencies
  include loris::install
  include loris::apache
  include loris::apache::vhost
  include loris::cache
  include loris::demo


}
