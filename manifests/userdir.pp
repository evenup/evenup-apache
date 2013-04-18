# == Class: apache::userdir
#
# This class sets up userdirs in apache
#
#
# === Examples
#
# * Installation:
#     class { 'apache::userdir': }
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
class apache::userdir {

  apache::cfgfile { 'userdir':
    filename  => 'userdir.conf',
    content   => template('apache/userdir.conf'),
  }

}
