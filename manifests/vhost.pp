# == Define: apache::vhost
#
# This class generates and installs apache vhosts.  It supports http -> https
# redirection, ajp proxy, thin proxy, ssl certificate management, and local
# sites.
#
#
# === Parameters
#
# [*serverName*]
#   String. Name of the vhost.
#   Required
#
# [*serverAlias*]
#   String.  Comma separated list of vhost aliases
#   Array.  Array of vhost aliases
#
# [*port*]
#   Integer.  Port the vhost is listening on.  This definition takes care of
#   making sure apache is correctly listening to that port.
#
# [*serverAdmin*]
#   String.  Email address of the ServerAdmin
#   Default is admin@letsevenup.com
#
# [*order*]
#   Integer.  Allows for ordering changes when apache processes config files.
#   Default is 99.  Module configs are 00 for reference.
#
# [*aliases*]
#   String.  Individual apache alias
#   Array.  Array of strings, each being a valid apache alias directive
#
# [*scriptAliases*]
#   String.  Individual apache ScriptAlias
#   Array.  Array of strings, each being a valid apache ScriptAlias directive
#
# [*auth*]
#   Boolean.  If true:
#     * Enables HTTP auth processing
#     * Requires authParams is defined
#
# [*authParams*]
#   Array.  This is an array of all required apache auth params
#
# [*log_level*]
#   String.  Logging level for this vhost.  Valid options are:
#   emerg, alert, crit,error,warn,notice,info,debug,trace[1-8]
#   Default is warn
#   NOTE: the perferred variable name for this was logLevel, but that is a reserved word in puppet
#
# [*redirectToHTTPS*]
#   Boolean.  This will redirect a virtual host from http to https.
#   Proxy options, auth options, and docroot CANNOT be set when true.
#
# [*targetPort*]
#   Integer.  Port of the target HTTPs service.
#   Default is 443
#
# [*ssl*]
#   Boolean.  If true:
#     * Ensure apache is configured for SSL
#     * Enable the SSL engine for this vhost
#     * Requires sslCert to be defined
#
# [*sslCert*]
#   String.  Ensures the SSL certificate specified is installed.
#
# [*sslChainFile*]
#   String.  What chainfile (if any) should be used for the SSL cert
#
# [*rewrite_to_https*]
#   Boolean.  Should apache rewrite headers on responses from http to https
#   Default is false
#
# [*proxy*]
#   Boolean.  When true, proxy engine is enabled
#   Default is false
#   None of the static website options can be set when using the proxy engine
#
# [*proxyTomcat*]
#   Boolean.  Enable AJP proxying for tomcat.
#   Default is false
#
# [*ajpHost*]
#   String.  AJP target host.
#   Default is localhost
#
# [*ajpPort*]
#   Integer.  AJP port tomcat is listening on.
#   Default is 8009
#
# [*proxyThin*]
#   Boolean.  Enable proxy balancer for ruby thin servers
#   Default is false
#
# [*thinPort*]
#   Integer.  Base port for the thin server
#   Default is 3000
#
# [*thinNumServers*]
#   Integer.  Number of started thin servers
#   Default 3
#
# [*proxyUrl*]
#   String.  Relative URL of the proxied request
#   Default is empty
#
# [*proxyDest*]
#   String.  Destination URL of the proxied request (used in conjunction with proxyUrl
#   Default is empty
#
# [*docroot*]
#   String.  Docroot when serving local content
#
# [*options*]
#   String. List of options for the vhost
#   Array. Array of strings that will be combined in the vhost
#
# [*addHandler*]
#   String.  Apache handler to add for the vhost
#
# [*siteDirectives*]
#   String. Free-form site options to add
#   Array. Array of directory option strings
#
# [*directoryIndex*]
#   String.  Site DirectoryIndex
#
# [*locations*]
#   Array of hashes. Format:
#   [ {'name' => 'locationName', 'params' => ['param1', 'param2','param3']}, {}]
#   Designed to allow an arbitrary number of additional locations, all
#   parameters need to be included in the param key in the hash.
#
# [*modSecOverrides*]
#   Boolean.  Enable mod_security override parameters
#   Default: false
#
# [*modSecOff*]
#   Boolean.  Disable mod_security for the vhost
#   Array.  An array of locations mod_security should be disabled for
#   Default: false
#
# [*modSecDisableByIP*]
#   String or Array.  List of IP addresses mod_security should be disabled for on the vhost
#
# [*modSecRemoveById*]
#   String or Array.  mod_security rules that should be disabled for the entire vhost
#   Hash. A list of locations and the associated rules that should be disabled
#   Example: $modSecRemoveById = {'/path/somewhere' => ['1234', '2345', '456'] }
#
# [*modSecBodyLimit*]
#   Integer.  Set the SecRequestBodyLimit for the vhost.  Size in Bytes
#
# [*logstash*]
#   Boolean.  If true, JSON logfiles created and beaver stanza added
#
# === Examples
#
#   apache::vhost {
#     'www-http':
#       serverName      => $::fqdn,
#       serverAlias     => someone@mydomain.com,
#       redirectToHTTPS => true;
#    }
#
#   apache::vhost {
#     'www-https':
#       serverName  => $::fqdn,
#       serverAlias => "www www.domain.com www.${::fqdn}",
#       proxy       => true,
#       proxyTomcat => true,
#       port        => 443,
#       ssl         => true,
#       sslCert     => 'mysite.com';
#   }
#
# * Removal:
#     Remove the definition and the apache class will clean it up
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
define apache::vhost (
  # Generic Config
  $serverName,
  $serverAlias        = '',
  $port               = '80',
  $serverAdmin        = 'admin@letsevenup.com',
  $order              = '99',
  $aliases            = '',
  $scriptAliases      = '',
  $auth               = false,
  $authParams         = [],
  $log_level          = 'warn',
  $redirectToHTTPS    = false,
  $targetPort         = '443',
  # SSL Config
  $ssl                = false,
  $sslCert            = '',
  $sslChainFile       = '',
  $rewrite_to_https   = false,
  # Proxy config
  $proxy              = false,
  # Tomcat proxy config
  $proxyTomcat        = false,
  $ajpHost            = 'localhost',
  $ajpPort            = '8009',
  # Thin proxy config
  $proxyThin          = false,
  $thinPort           = '3000',
  $thinNumServers     = '3',
  # URL Proxy config
  $proxyUrl           = '',
  $proxyDest          = '',
  # Static config
  $docroot            = '',
  $options            = '',
  $addHandler         = '',
  $siteDirectives     = '',
  $directoryIndex     = '',
  $locations          = [],
  # Mod Security overrides
  $modSecOverrides    = false,
  $modSecOff          = false,
  $modSecDisableByIP  = '',
  $modSecRemoveById   = '',
  $modSecBodyLimit    = '',
  # Logging
  $logstash           = false,
) {

  include apache

  # Input validation
  validate_bool( $ssl, $auth, $redirectToHTTPS, $proxy, $proxyTomcat, $proxyThin )
  validate_array( $authParams, $locations )
  validate_re( $log_level, ['^emerg$', '^alert$', '^crit$', '^error$', '^warn$', '^notice$', '^info$', '^debug$', '^trace[1-8]$'], 'Invalid apache LogLevel' )
  validate_string ($serverName, $sslCert, $ajpHost, $proxyUrl, $proxyDest, $docroot, $addHandler, $directoryIndex, $serverAdmin)

  # What characters should not be in filenames
  $bad_chars = '\.\\\/'

  # Local variables
  $name_real = regsubst($name, "[${bad_chars}]", '_', 'G')
  $filename_real = "${name_real}.conf"
  $errorlog_real = "${name_real}_error.log"
  $logfile_proxied_real = "${name_real}_access_proxied.log"
  $logfile_direct_real = "${name_real}_access_direct.log"

  if !defined(Apache::Namevhost[$port]) {
    apache::namevhost { $port: }
  }

  concat {
    "/etc/httpd/conf.d/${order}-${filename_real}":
    owner   => 'apache',
    group   => 'apache',
    require => Package['httpd'],
    notify  => Service['httpd'];
  }

  concat::fragment { "vhost_01-header_${name}":
    target  => "/etc/httpd/conf.d/${order}-${filename_real}",
    content => template('apache/vhost/01-header.conf.erb'),
    order   => 01;
  }

  if $redirectToHTTPS {
    concat::fragment { "vhost_10-redirect_http_${name}":
      target  => "/etc/httpd/conf.d/${order}-${filename_real}",
      content => template('apache/vhost/10-redirect_http.conf.erb'),
      order   => 10;
    }
  }

  if $ssl {
    concat::fragment { "vhost_15-ssl_${name}":
      target  => "/etc/httpd/conf.d/${order}-${filename_real}",
      content => template('apache/vhost/15-ssl.conf.erb'),
      order   => 15;
    }
  }

  if $aliases != '' or $scriptAliases != '' {
    concat::fragment { "vhost_20-aliases_${name}":
      target  => "/etc/httpd/conf.d/${order}-${filename_real}",
      content => template('apache/vhost/20-aliases.conf.erb'),
      order   => 20;
    }
  }

  if $siteDirectives != '' {
    concat::fragment { "vhost_25-site_directives_${name}":
      target  => "/etc/httpd/conf.d/${order}-${filename_real}",
      content => template('apache/vhost/25-site_directives.conf.erb'),
      order   => 25;
    }
  }

  if $docroot != '' {
    concat::fragment { "vhost_30-docroot_${name}":
      target  => "/etc/httpd/conf.d/${order}-${filename_real}",
      content => template('apache/vhost/30-docroot.conf.erb'),
      order   => 30;
    }
  }

  if $proxy {
    if $proxyTomcat {
      concat::fragment { "vhost_35-proxy_tomcat_${name}":
        target  => "/etc/httpd/conf.d/${order}-${filename_real}",
        content => template('apache/vhost/35-proxy_tomcat.conf.erb'),
        order   => 35;
      }
    } elsif $proxyThin {
      concat::fragment { "vhost_35-proxy_thin_${name}":
        target  => "/etc/httpd/conf.d/${order}-${filename_real}",
        content => template('apache/vhost/35-proxy_thin.conf.erb'),
        order   => 35;
      }
    } else {
      # TODO - throw error if proxyDest not set
      concat::fragment { "vhost_35-proxy_generic_${name}":
        target  => "/etc/httpd/conf.d/${order}-${filename_real}",
        content => template('apache/vhost/35-proxy_generic.conf.erb'),
        order   => 35;
      }
    }
  }

  if $locations != [] {
    concat::fragment { "vhost_40-locations_${name}":
      target  => "/etc/httpd/conf.d/${order}-${filename_real}",
      content => template('apache/vhost/40-locations.conf.erb'),
      order   => 40;
    }
  }

  if $modSecOverrides {
    concat::fragment { "vhost_45-modsec_${name}":
      target  => "/etc/httpd/conf.d/${order}-${filename_real}",
      content => template('apache/vhost/45-modsec.conf.erb'),
      order   => 45;
    }
  }

  concat::fragment { "vhost_99-_footer_${name}":
    target  => "/etc/httpd/conf.d/${order}-${filename_real}",
    content => template('apache/vhost/99-footer.conf.erb'),
    order   => 99;
  }

  if $logstash {
    beaver::stanza { "/var/log/httpd/${name_real}_access.json":
      type    => 'apache',
      tags    => ['access', $name, $::disposition],
      format  => 'rawjson',
    }
  }
}
