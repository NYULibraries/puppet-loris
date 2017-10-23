# == Class: loris::cache
#
# Manage the loris image cache maintenance script
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
class loris::cache(
  String $user_home = lookup('$loris::user_home', String, 'first'),
){
    file { '/var/log/loris2' :
      ensure => directory,
      owner  => $user,
      group  => $user,
      mode   => '0755',
    }
    # Clean the loris cache once a day at midnight.
    # This is a preliminary value and will need to be adjusted
    # once the server is running in production.
    cron { 'loris-cache_clean.sh':
      ensure  => present,
      command => "${user_home}/setup/loris2/bin/loris-cache_clean.sh",
      user    => $user,
      hour    => '0',
      minute  => '5',
    }
}
