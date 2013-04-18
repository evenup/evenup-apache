# == Class: apache::python
#
# This class installs mod_python for apache.
#
#
# === Examples
#
# * Installation:
#     class { 'apache::python': }
#
#
# === Authors
#
# * Justin Lambert <mailto:jlambert@letsevenup.com>
#
#
# === Copyright
#
# Copyright 2013 EvenUp.
#
class apache::python inherits apache {

  package {
    'mod_python':
      ensure  => 'present',
      require => Class['apache::install'],
      notify  => Class['apache::service'];
  }

  apache::cfgfile {
    'python':
      filename  => 'python.conf',
      content   => template('apache/python.conf');
  }
}
