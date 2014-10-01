# == Class: apache::params
#
# This class sets default apache params
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
class apache::params {

  $ensure               = 'latest'
  # mod_security
  $mod_sec              = true
  $activated_rules      = [
    'modsecurity_35_bad_robots.data',
    'modsecurity_35_scanners.data',
    'modsecurity_40_generic_attacks.data',
    'modsecurity_41_sql_injection_attacks.data',
    'modsecurity_50_outbound.data',
    'modsecurity_50_outbound_malware.data',
    'modsecurity_crs_20_protocol_violations.conf',
    'modsecurity_crs_21_protocol_anomalies.conf',
    'modsecurity_crs_23_request_limits.conf',
    'modsecurity_crs_30_http_policy.conf',
    'modsecurity_crs_35_bad_robots.conf',
    'modsecurity_crs_40_generic_attacks.conf',
    'modsecurity_crs_41_sql_injection_attacks.conf',
    'modsecurity_crs_41_xss_attacks.conf',
    'modsecurity_crs_42_tight_security.conf',
    'modsecurity_crs_45_trojans.conf',
    'modsecurity_crs_47_common_exceptions.conf',
    'modsecurity_crs_49_inbound_blocking.conf',
    'modsecurity_crs_50_outbound.conf',
    'modsecurity_crs_59_outbound_blocking.conf',
    'modsecurity_crs_60_correlation.conf'
  ]
  $modsec_protocols     = 'application/x-www-form-urlencoded|multipart/form-data|text/xml|application/xml|application/x-amf'
  $modsec_restrict_ext  = '.asa/ .asax/ .ascx/ .axd/ .backup/ .bak/ .bat/ .cdx/ .cer/ .cfg/ .cmd/ .com/ .config/ .conf/ .cs/ .csproj/ .csr/ .dat/ .db/ .dbf/ .dll/ .dos/ .htr/ .htw/ .ida/ .idc/ .idq/ .inc/ .ini/ .key/ .licx/ .lnk/ .log/ .mdb/ .old/ .pass/ .pdb/ .pol/ .printer/ .pwd/ .resources/ .resx/ .sql/ .sys/ .vb/ .vbs/ .vbproj/ .vsdisco/ .webinfo/ .xsd/ .xsx/'
  $modsec_version       = 'latest'
  $modsec_crs_version   = 'latest'
  # mod_evasive
  $mod_evasive          = true
  $mod_evasive_version  = 'latest'
  $logging              = ''
  $monitoring           = ''
}
