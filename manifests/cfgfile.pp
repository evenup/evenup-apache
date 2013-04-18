# == Definition: apache::cfgfile
#
# This define adds a config file to apache
#
# === Parameters
#
# [*content*]
#   String.  Content (or template) of the config file
#
# [*filename*]
#   String.  Output filename
#
# [*ensure*]
#   String.  [present|absent]
#
# [*order*]
#   Apache load order
#
#
# === Requires
#
#   apache
#
#
# === Examples
#
#   apache::cfgfile {
#     'ssl':
#       ensure    => 'present',
#       content   => template('apache/ssl.conf'),
#       filename  => 'ssl.conf';
#   }
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
define apache::cfgfile( 
  $content, 
  $filename, 
  $ensure = 'present', 
  $order  = '00'
) {

  file { "/etc/httpd/conf.d/${order}-${filename}":
    ensure  => $ensure,
    owner   => 'apache',
    group   => 'apache',
    content => $content,
    require => Class['apache::install'],
    notify  => Class['apache::service'];
  }
}
