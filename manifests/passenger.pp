# == Class: apache::passenger
#
# This class sets up an apache NameVirtualHost.
#
#
# === Parameters
#
#
# === Examples
#
# * Installation:
#     class { 'apache::passenger': }
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
class apache::passenger inherits apache {

  package {
    'mod_passenger':
      ensure  => installed;
  }

  apache::cfgfile {
    'passenger':
      filename  => 'passenger.conf',
      content   => template('apache/passenger.conf');
  }

}
