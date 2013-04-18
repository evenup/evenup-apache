# == Class: apache
#
# This class installs and configures apache
#
#
# === Parameters
#
# [*mod_sec*]
#   Boolean.  Should mod_security be enabled?
#   Default: true
#
#
# === Examples
#
# * Installation:
#     class { 'apache': }
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
class apache(
  $mod_sec = true
) {

  include apache::status

  class { 'apache::install': } ->
  class { 'apache::mod_security': ensure => $mod_sec} ->
  class { 'apache::mod_evasive': } ->
  class { 'apache::service': } ->
  Class['apache']

}
