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
  String $default_vhost = lookup('loris::default_vhost', Boolean, 'first'),
){
  include loris::packages
  include loris::install
  include loris::apache
  include loris::apache::vhost
  include loris::cache
  include loris::demo
}
