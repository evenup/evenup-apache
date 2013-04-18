# == Class: apache::ssl
#
# This class sets mod_ssl for apache
#
#
# === Examples
#
# * Installation:
#     class { 'apache::ssl': }
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
class apache::ssl inherits apache {

  package { 'mod_ssl':
    ensure  => 'present',
    notify  => Class['apache::service'],
  }

  apache::cfgfile { 'ssl.conf':
    filename  => 'ssl.conf',
    content   => template('apache/ssl.conf'),
  }
}
