# == Class: apache::monitoring::sensu
#
# Adds sensu monitoring to apache hosts
#
#
# === Authors
#
# * Justin Lambert <mailto:jlambert@letsevenup.com>
#
# === Copyright
#
# Copyright 2013 EvenUp.
#
class apache::monitoring::sensu {

  # Checking httpd is running
  sensu::check { 'apache-running':
    handlers => 'default',
    command  => '/etc/sensu/plugins/check-procs.rb -p /usr/sbin/httpd -w 100 -c 200 -C 1',
    custom   => { 'playbook' => 'https://evenup.atlassian.net/wiki/display/ADMIN/CheckProcs+%5Bapache-running%5D%3A+Found+%7Bx%7D+matching+processes' },
  }

  # Metrics
  sensu::check { 'apache-metrics':
    type     => 'metric',
    handlers => 'graphite',
    command  => '/etc/sensu/plugins/apache-metrics.rb -h localhost -p 88',
  }

  sensu::subscription { 'apache': }

}
