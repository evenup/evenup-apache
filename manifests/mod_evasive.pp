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
class apache::mod_evasive {

  if $caller_module_name != $module_name {
    fail("Use of private class ${name} by ${caller_module_name}")
  }

  case $apache::mod_evasive {
    true:     {
      $version    = $apache::mod_evasive_version
      $cfg_ensure = 'present'
    }
    default:  {
      $version    = 'absent'
      $cfg_ensure = 'absent'
    }
  }

  package { 'mod_evasive':
    ensure => $version,
    notify => Class['apache::service'],
  }

  file { '/etc/httpd/conf.d/mod_evasive.conf':
    ensure  => absent,
    require => Package['mod_evasive'],
  }

  apache::cfgfile { 'mod_evasive.conf':
    ensure   => $cfg_ensure,
    content  => template('apache/mod_evasive.conf'),
    filename => 'mod_evasive.conf',
    require  => Package['mod_evasive'],
  }

}
