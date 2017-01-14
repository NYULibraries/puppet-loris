# == Class: loris
#
class loris::install {

  # The double case is a bit uggly, but centos 6 i
  # requires a whole different approach.
  case $::osfamily {
    redhat  : {
      case $::operatingsystemmajrelease {
        #/^7*/: {
        '7' : {
          require loris::install::redhat7
        }
        default : { notice("${::operatingsystemmajrelease} is not supported at this time.") }
      }
    }
    default : { notice("${::osfamily} is not supported at this time.") }
  }
  #file { '/etc/httpd/conf.d/0-loris.conf':
  #  ensure => present,
  #  source => 'puppet:///modules/loris/0-loris.conf',
  #  owner  => 'root',
  #  group  => 'root',
  #  mode   => '0755',
  #}
}
