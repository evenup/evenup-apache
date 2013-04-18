# == Class: apache::wsgi
#
# This class installs mod_wsgi for apache
#
#
# === Examples
#
# * Installation:
#     class { 'apache::wsgi': }
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
class apache::wsgi {

  package { 'mod_wsgi':
    ensure  => 'present',
    require => Class['apache::install'],
    notify  => Class['apache::service'],
  }

  file { '/var/run/wsgi':
    ensure  => directory,
    owner   => 'apache',
    group   => 'apache',
    require => Class['apache::install'],
    mode    => 0770,
  }

  apache::cfgfile { 'wsgi':
    filename  => 'wsgi.conf',
    content   => template('apache/wsgi.conf'),
  }
}
