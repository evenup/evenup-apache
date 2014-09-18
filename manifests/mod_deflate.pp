# == Class: apache::mod_deflate
#
# This class configures mod_deflate
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
class apache::mod_deflate {

  apache::cfgfile { 'mod_deflate.conf':
    content  => template('apache/mod_deflate.conf'),
    filename => 'mod_deflate.conf',
  }

}

