# == Define: apache::securefile
#
# This define installs secure files within apache such as SSL certificates and password files.
#
#
# === Parameters
#
# [*content*]
#   String. The content of the secure file
#
# [*filename*]
#   String.  The filename that should be written on disk
#
# [*ensure*]
#   String.  Controls if the file exists or is absent.  Default is present.
#
#
# === Examples
#
#   apache::securefile {
#     'ssl':
#       ensure    => 'present',
#       source    => template('apache/ssl.conf'),
#       filename  => 'ssl.conf';
#   }
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
define apache::securefile (
  $source,
  $filename,
  $ensure = 'present'
) {

  file {
    "/etc/httpd/secure/${filename}":
      ensure  => $ensure,
      owner   => 'apache',
      group   => 'apache',
      source  => $source,
      require => Class['apache::install'],
      notify  => Class['apache::service'];
  }
}
