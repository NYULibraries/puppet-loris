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
class loris {

  notice('From init.pp in the loris module. ###')
  include loris::dependencies
  #include loris::apache_vhost
  include loris::install

}
