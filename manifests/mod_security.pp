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
class apache::mod_security {

  if $caller_module_name != $module_name {
    fail("Use of private class ${name} by ${caller_module_name}")
  }

  case $apache::mod_sec {
    true:  {
      $modsec_version = $apache::modsec_version
      $crs_version    = $apache::modsec_crs_version
      $cfg_ensure     = 'present'
      $dir_ensure     = 'directory'
      $dir_source     = 'puppet:///modules/apache/mod_security.d'
    }
    default:                {
      $modsec_version = 'absent'
      $crs_version    = 'absent'
      $cfg_ensure     = 'absent'
      $dir_ensure     = 'absent'
      $dir_source     = undef
    }
  }

  package { 'mod_security':
    ensure => $modsec_version,
    notify => Class['apache::service'],
  }

  package { 'mod_security_crs':
    ensure => $crs_version,
    notify => Class['apache::service'],
  }

  file { '/etc/httpd/conf.d/mod_security.conf':
    ensure  => absent,
    require => Package['mod_security'],
  }

  apache::cfgfile { 'mod_security.conf':
    ensure   => $cfg_ensure,
    content  => template('apache/mod_security.conf'),
    filename => 'mod_security.conf',
  }

  file { [ '/etc/httpd/modsecurity.d', '/etc/httpd/modsecurity.d/activated_rules' ]:
    ensure  => $dir_ensure,
    owner   => 'apache',
    group   => 'apache',
    purge   => true,
    force   => true,
    recurse => true,
    notify  => Class['apache::service'],
    require => [ Package['mod_security'], Package['mod_security_crs'] ]
  }

  file { '/etc/httpd/modsecurity.d/modsecurity_crs_10_config.conf':
    ensure  => 'file',
    owner   => 'apache',
    group   => 'apache',
    mode    => '0444',
    content => template('apache/modsecurity_crs_10_config.conf.erb')
  }

  modsec_link { $apache::activate_rules: }

  case $apache::logging {
    'beaver': {
      beaver::stanza { '/var/log/httpd/modsec_audit.log':
        type => 'modsecurity',
        tags => [ $::disposition ],
      }
    }

    default: {}
  }
}
