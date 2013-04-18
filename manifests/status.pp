# == Class: apache::status
#
# This class installs and configures the apache status module
#
#
# === Examples
#
# * Installation:
#     class { 'apache::status': }
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
class apache::status inherits apache {

  apache::cfgfile { 'status':
    filename  => 'status.conf',
    content   => template('apache/status.conf');
  }
}
