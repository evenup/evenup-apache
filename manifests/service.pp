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

  service {
    'httpd':
      ensure    => running,
      enable    => true,
      require   => Class['apache::install'],
      # TODO mod_security seems to be unhappy with graceful
#      restart   => '/etc/init.d/httpd graceful';
  }

  # Monitoring
  $monitoring = hiera('monitoring', '')

  case $monitoring {
    'sensu':  {
      include apache::monitoring::sensu
    }
  }
}
