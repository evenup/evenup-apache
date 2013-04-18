# == Class: apache::mod_evasive
#
# This class installs and configures mod_evasive
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
class apache::mod_evasive  {

  package { 'mod_evasive':
    ensure  => 'present',
    notify  => Class['apache::service'],
  }

  file { '/etc/httpd/conf.d/mod_evasive.conf':
    ensure  => absent,
    require => Package['mod_evasive'],
  }

  apache::cfgfile { 'mod_evasive.conf':
    content   => template('apache/mod_evasive.conf'),
    filename  => 'mod_evasive.conf',
    require   => Package['mod_evasive'],
  }

}
