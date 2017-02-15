# == Class: loris
#
class loris::dependencies::redhat7 {

  notice('notice from loris::dependencies::redhat7  ----------')
  # The following package list is a bit overkill, but it's what
  # I've got from my current list of installation instructions
  # so I'll go with it for now and pair it down to the essentials
  # once I get a chance.
  ensure_packages([
    # Mandatory and default packages from yum gourp Development Tools
    # minus a few obvious ones that I could kick now.
    'autoconf',
    'automake',
    'binutils',
    'gcc',
    'gcc-c++',
    'gettext',
    'libtool',
    'make',
    'patch',
    'pkgconfig',
    'python-virtualenv.noarch',
    'redhat-rpm-config',
    'rpm-build',
    'byacc',
    'cscope',
    'ctags',
    'cvs',
    'diffstat',
    'doxygen',
    'elfutils',
    'gcc-gfortran',
    'git',
    'indent',
    'intltool',
    'patchutils',
    'rcs',
    'swig',
    'systemtap',
    # Other packages required by loris
    'bzip2',
    'bzip2-devel',
    'epel-release',
    'freetype',
    'freetype-devel',
    'libtiff',
    'libtiff-devel',
    'libjpeg-turbo',
    'libjpeg-turbo-devel',
    'openssl-devel',
    'readline-devel',
    'sqlite',
    'sqlite-devel',
    'tk-devel',
    'zlib-devel',
  ],
  {'ensure' => 'present'}
  )

}
