# == Class: apache::install
#
# This class installs apache
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
class apache::install {

  if $caller_module_name != $module_name {
    fail("Use of private class ${name} by ${caller_module_name}")
  }

  package { 'httpd':
    ensure  => $apache::ensure;
  }

  File {
    owner   => 'apache',
    group   => 'apache',
    require => Package['httpd'],
  }

  file { '/etc/sysconfig/httpd':
    ensure => 'file',
    mode   => '0444',
    source => 'puppet:///modules/apache/httpd.sysconfig',
    notify => Class['apache::service'],
  }

  file { '/etc/httpd/conf/httpd.conf':
    ensure => 'file',
    mode   => '0444',
    source => 'puppet:///modules/apache/httpd.conf',
    notify => Class['apache::service'],
  }

  file { '/etc/httpd/conf.d/':
    ensure  => 'directory',
    mode    => '0555',
    recurse => true,
    purge   => true,
    force   => true,
    notify  => Class['apache::service'],
  }

  file { '/etc/httpd/secure/':
    ensure  => 'directory',
    group   => 'wheel',
    mode    => '0550',
    purge   => true,
    force   => true,
    recurse => true,
    notify  => Class['apache::service'],
  }

  file { '/var/log/httpd/':
    ensure => 'directory',
    owner  => 'root',
    group  => 'wheel',
    mode   => '0775',
  }
}
