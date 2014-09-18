# == Definition: apache::modsec_link
#
# This defined type creates symlinks for modsec rule files
#
#
# === Authors
#
# * Justin Lambert <mailto:jlambert@letsevenup.com>
#
#
# === Copyright
#
# Copyright 2014 EvenUp.
#
define apache::modsec_link () {

  file { $title:
    ensure => 'link',
    path   => "/etc/httpd/modsecurity.d/activated_rules/${title}",
    target => "/usr/lib/modsecurity.d/base_rules/${title}",
  }
}
