# == Class: apache::mod_security
#
# This class installs and configures or removes mod_security
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
class apache::mod_security(
  $ensure = true,
) {

  case $ensure {
    true:  {
      $package_ensure = 'latest'
      $cfg_ensure     = 'present'
      $dir_ensure     = 'directory'
      $dir_source     = 'puppet:///modules/apache/mod_security.d'
    }
    default:                {
      $package_ensure = 'absent'
      $cfg_ensure     = 'absent'
      $dir_ensure     = 'absent'
      $dir_source     = undef
    }
  }

  package { 'mod_security':
    ensure  => $package_ensure,
    notify  => Class['apache::service'],
  }

  file { '/etc/httpd/conf.d/mod_security.conf':
    ensure  => absent,
    require => Package['mod_security'],
  }

  apache::cfgfile { 'mod_security.conf':
    content   => template('apache/mod_security.conf'),
    filename  => 'mod_security.conf',
    ensure    => $cfg_ensure,
  }

  file { '/etc/httpd/modsecurity.d/':
    ensure  => $dir_ensure,
    owner   => apache,
    group   => apache,
    purge   => true,
    force   => true,
    recurse => true,
    notify  => Class['apache::service'],
    require => Package['mod_security'],
    source  => $dir_source,
  }
}
