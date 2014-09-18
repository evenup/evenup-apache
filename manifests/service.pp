# == Class: apache::install
#
# This class controls the apache service.
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
class apache::service {

  if $caller_module_name != $module_name {
    fail("Use of private class ${name} by ${caller_module_name}")
  }

  service {
    'httpd':
      ensure  => running,
      enable  => true,
      require => Class['apache::install'],
      # TODO mod_security seems to be unhappy with graceful
#      restart   => '/etc/init.d/httpd graceful';
  }

  case $apache::monitoring {
    'sensu':  {
      include apache::monitoring::sensu
    }
    default:  {}
  }
}
