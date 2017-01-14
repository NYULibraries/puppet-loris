# loris

#### Table of Contents

1. [Overview](#overview)
2. [Module Description - What the module does and why it is useful](#module-description)
3. [Setup - The basics of getting started with loris](#setup)
    * [What loris affects](#what-loris-affects)
    * [Setup requirements](#setup-requirements)
    * [Beginning with loris](#beginning-with-loris)
4. [Usage - Configuration options and additional functionality](#usage)
5. [Reference - An under-the-hood peek at what the module is doing and how](#reference)
5. [Limitations - OS compatibility, etc.](#limitations)
6. [Development - Guide for contributing to the module](#development)

#### Overview

Manages loris image server

#### Compatibility

This module has been test on the following systems with Puppet version v4.

  * Centos 7

#### Setup

##### Parameters



#### Usage

On a clean system this module can be used to manage loris after installing apache from teh Puppetlabs apache module.  For full support on a clean system it can be deployed as follows


    include loris
    include loris::apache
    include loris::apache::vhost

    Class['loris::apache']->Class['loris::apache::vhost']->Class['loris']

On a system with an existing apache installation loris can be managed in the following manner,

    include loris::apache::vhost
    include loris


#### Limitations

Currently this module has only been test on Centos 7 with Puppet v4.8 and python 2.7.5

#### Development


#### Contributors

Flannon Jackson | Chris Fitzpatrick

