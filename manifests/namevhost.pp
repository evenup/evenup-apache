# == Define: apache::namevhost
#
# This class sets up an apache NameVirtualHost.
#
#
# === Parameters
#
#
# === Examples
#
# * Installation:
#     apache::namevhost { '80': }
#
# * Removal/decommissioning:
#     Remove the definition
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
define apache::namevhost {

  apache::cfgfile { "name-vhost-${name}":
    content   => "#Managed by puppet - do not modify\nListen ${name}\nNameVirtualHost *:${name}\n",
    filename  => "namevirtualhost-${name}.conf",
    order     => '01',
  }
}
