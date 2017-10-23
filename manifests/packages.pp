# == Class: loris::packages
#
class loris::packages {
  # The double case is a bit uggly, but centos 6 i
  # requires a whole different approach.
  case $::osfamily {
    redhat  : {
      case $::operatingsystemmajrelease {
        #/^7*/: {
        '7' : {
          require loris::dependencies::redhat7
        }
        default : { notice("${::operatingsystemmajrelease} is not supported at this time.") }
      }
    }
    default : { notice("${::osfamily} is not supported at this time.") }
  }
}
