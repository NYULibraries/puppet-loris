# puppet-loris

#### Table of Contents

1. [Overview](#overview)
2. [Compatability](#compatability)
3. [Parameter](#parameters)
4. [Usage](#usage)
5. [Limitations - OS compatibility, etc.](#limitations)
6. [Development - Guide for contributing to the module](#development)
5. [To Do](#to do)
5. [Contributors](#contributors)

#### Overview

Manages the loris image server


#### Compatibility

This module has been tested on the following systems with Puppet version v4.

  * Centos 7


##### Parameters


#### Usage

On a clean system this module can be used to manage loris after installing apache from the Puppetlabs apache module.  For complete installaiton is can be deployed as follows,

    include loris
    include loris::apache
    include loris::apache::vhost
    include loris::cache
    include loris::demo

The loris module classes provide the following funcitonality

 *  loris
    Installs loris and it's dependencies.
 
 *  loris::apache
    Installs and configures apache using the puppetlabs-apache module.

 *  loris::vhost
    Writes the loris vhost definition, configuring the wsgi server.

 * loris::cache
   Enables cache maintenance by enabling loris-cache_clean.sh from a cron job owned by the loris user. 

 * loris::demo
   Installs a demo jp2 image, which can be seen at http://localhost/loris/001.jp2/full/440,/0/default.png
  

#### Limitations

Currently this module has only been tested with loris v2.1.0-final, on a system running Centos 7, Puppet v4.8 and python 2.7.5.


#### Development


#### To Do

  * Define ExpiresActive in vhost.pp


#### Contributors

Flannon Jackson | Chris Fitzpatrick

