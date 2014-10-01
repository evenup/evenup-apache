# == Class: apache
#
# This class installs and configures apache
#
#
# === Parameters
#
# [*ensure*]
#   String.  Version of apache to install
#   Default: latest
#
# [*mod_sec*]
#   Boolean.  Should mod_security be enabled?
#   Default: true
#
# [*modsec_version*]
#   String.  Version of mod_security to install.
#   Default: latest
#
# [*modsec_crs_version]
#   String.  Version of mod_security_crs package to install
#   Default: latest
#
# [*activate_rules*]
#   Array of strings.  List of rules to enable.  See params.pp for the list
#   Default:  All crs rules
#
# [*logging*]
#   String.  Should remote logging be used?
#   Default: blank
#
# [*monitoring*]
#   String.  What monitoring should be used
#   Default: blank
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
class apache (
  $ensure               = $apache::params::ensure,
  # mod_security
  $mod_sec              = $apache::params::mod_sec,
  $modsec_version       = $apache::params::modsec_version,
  $modsec_crs_version   = $apache::params::modsec_crs_version,
  $activate_rules       = $apache::params::activated_rules,
  $modsec_protocols     = $apache::params::modsec_protocols,
  $modsec_restrict_ext  = $apache::params::modsec_restrict_ext,
  # mod_evasive
  $mod_evasive          = $apache::params::mod_evasive,
  $mod_evasive_version  = $apache::params::mod_evasive_version,
  # monitoring
  $logging              = $apache::params::logging,
  $monitoring           = $apache::params::monitoring,
) inherits apache::params {

  include apache::status

  anchor { 'apache::begin': } ->
  class { 'apache::install': } ->
  class { 'apache::mod_security': } ->
  class { 'apache::mod_evasive': } ->
  class { 'apache::mod_deflate': } ->
  class { 'apache::service': } ->
  anchor { 'apache::end': }

}
