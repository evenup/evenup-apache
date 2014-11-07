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
# [*proxyExclude*]
#   String or Array of strings.  Paths to be excluded from being proxied.
#   Default: []
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
# [*proxyTomcatUrl*]
#   String.  Overrides proxyUrl for tomcat vhosts if set
#   Default is ''
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
# [*proxyThinUrl*]
#   String.  Overrides proxyUrl for thin vhosts if set
#   Default is ''
#
# [*proxyUrl*]
#   String.  Relative URL of the proxied request
#   Default is empty
#
# [*proxyDest*]
#   String.  Destination URL of the proxied request (used in conjunction with proxyUrl)
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
# [*errorDocs*]
#   Array of hashes.  Format:
#   [ { 'code' => '404', 'location' => '/404.html' }]
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
# [*modExpires*]
#   Boolean.  Whether mod_expires is enabled or not
#   Default: true
#
# [*expiresByType*]
#   Hash.  What the expire values per type should be.
#   The format is {type => time, type => time}
#   Apache documentation: http://httpd.apache.org/docs/2.2/mod/mod_expires.html
#   Default:
#     { 'image/gif'                 => 'access plus 1 months',
#       'image/jpg'                 => 'access plus 1 months',
#       'image/jped'                => 'access plus 1 months',
#       'image/png'                 => 'access plus 1 months',
#       'image/vnd.microsoft.icon'  => 'access plus 1 months',
#       'image/x-icon'              => 'access plus 1 months',
#       'image/ico'                 => 'access plus 1 months',
#       'application/javascript'    => 'now plus 1 months',
#       'application/x-javascript   => 'now plus 1 months',
#       'text/javascript'           => 'now plus 1 months',
#       'text/css'                  => 'now plus 1 months' }
#
#
# [*headers*]
#   String or Array of Strings.  Manage HTTP headers.  Values passed here will
#     be appended to the Header directive
#   Default: ''
#
# [*logstash*]
#   Boolean.  If true, JSON logfiles created and beaver stanza added
#   Defaults: false
#
# [*logstash_fields*]
#   Hash.  Custom fields to be added to the JSON output.
#   Default: {}
#
#
# === Examples
#
#   apache::vhost {
#     'www-http':
#       serverName      => $::fqdn,
#       serverAlias     => someone@mydomain.com,
#       redirectToHTTPS => true,
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
#       sslCert     => 'mysite.com',
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
  $aliases            = [],
  $scriptAliases      = [],
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
  $proxyExclude       = [],
  # Tomcat proxy config
  $proxyTomcat        = false,
  $ajpHost            = 'localhost',
  $ajpPort            = '8009',
  $proxyTomcatUrl     = '',
  # Thin proxy config
  $proxyThin          = false,
  $thinPort           = '3000',
  $thinNumServers     = '3',
  $proxyThinUrl       = '',
  # URL Proxy config
  $proxyUrl           = '',
  $proxyDest          = '',
  # Static config
  $docroot            = '',
  $docrootOverride    = 'None',
  $options            = '',
  $addHandler         = '',
  $siteDirectives     = '',
  $directoryIndex     = '',
  $locations          = [],
  $errorDocs          = [],
  # Mod Security overrides
  $modSecOverrides    = false,
  $modSecOff          = false,
  $modSecDisableByIP  = '',
  $modSecRemoveById   = '',
  $modSecBodyLimit    = '',
  # mod_expires
  $modExpires         = true,
  $modExpiresByType   = '',
  # Headers
  $headers            = '',
  # Logging
  $logstash           = false,
  $logstash_fields    = {},
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
  $proxyExclude_real = any2array($proxyExclude)
  $aliases_real = any2array($aliases)
  $scriptAliases_real = any2array($scriptAliases)

  $modExpireByTypeDefault = {
    'image/gif'                 => 'access plus 1 months',
    'image/jpg'                 => 'access plus 1 months',
    'image/jpeg'                => 'access plus 1 months',
    'image/png'                 => 'access plus 1 months',
    'image/vnd.microsoft.icon'  => 'access plus 1 months',
    'image/x-icon'              => 'access plus 1 months',
    'image/ico'                 => 'access plus 1 months',
    'application/javascript'    => 'now plus 1 months',
    'application/x-javascript'  => 'now plus 1 months',
    'text/javascript'           => 'now plus 1 months',
    'text/css'                  => 'now plus 1 months',
    'text/x-component'          => 'now plus 1 months'
  }

  $modExpiresByType_real = $modExpiresByType ? {
    ''        => $modExpireByTypeDefault,
      default => $modExpiresByType
  }

  if !defined(Apache::Namevhost[$port]) {
    apache::namevhost { $port: }
  }

  concat {
    "/etc/httpd/conf.d/${order}-${filename_real}":
    owner   => 'apache',
    group   => 'apache',
    require => Package['httpd'],
    notify  => Service['httpd'],
  }

  concat::fragment { "vhost_01-header_${name}":
    target  => "/etc/httpd/conf.d/${order}-${filename_real}",
    content => template('apache/vhost/01-header.conf.erb'),
    order   => 01,
  }

  if $modExpires == true or $modExpires == true {
    concat::fragment { "vhost_05-mod_expires_${name}":
      target  => "/etc/httpd/conf.d/${order}-${filename_real}",
      content => template('apache/vhost/05-mod_expires.conf.erb'),
      order   => 05,
    }
  }

  if $redirectToHTTPS {
    concat::fragment { "vhost_10-redirect_http_${name}":
      target  => "/etc/httpd/conf.d/${order}-${filename_real}",
      content => template('apache/vhost/10-redirect_http.conf.erb'),
      order   => 10,
    }
  }

  if $ssl {
    concat::fragment { "vhost_15-ssl_${name}":
      target  => "/etc/httpd/conf.d/${order}-${filename_real}",
      content => template('apache/vhost/15-ssl.conf.erb'),
      order   => 15,
    }
  }

  if $aliases != [] or $scriptAliases != [] {
    concat::fragment { "vhost_20-aliases_${name}":
      target  => "/etc/httpd/conf.d/${order}-${filename_real}",
      content => template('apache/vhost/20-aliases.conf.erb'),
      order   => 20,
    }
  }

  if $siteDirectives != '' {
    concat::fragment { "vhost_25-site_directives_${name}":
      target  => "/etc/httpd/conf.d/${order}-${filename_real}",
      content => template('apache/vhost/25-site_directives.conf.erb'),
      order   => 25,
    }
  }

  if $docroot != '' {
    concat::fragment { "vhost_30-docroot_${name}":
      target  => "/etc/httpd/conf.d/${order}-${filename_real}",
      content => template('apache/vhost/30-docroot.conf.erb'),
      order   => 30,
    }
  }

  if $proxy {
    if $proxyExclude_real != [] {
      concat::fragment { "vhost_31-proxypass_${name}":
      target  => "/etc/httpd/conf.d/${order}-${filename_real}",
      content => template('apache/vhost/31-proxypass.conf.erb'),
      order   => 31,
      }
    }

    # Apache processes matches in order not most exact match
    $tomcatOrder = inline_template('<%= if (@proxyTomcatUrl.length > @proxyThinUrl.length) || (@proxyUrl.length > @proxyThinUrl.length) then 35 else 37 end %>')

    if $proxyTomcat {
      concat::fragment { "vhost_35-proxy_tomcat_${name}":
        target  => "/etc/httpd/conf.d/${order}-${filename_real}",
        content => template('apache/vhost/35-proxy_tomcat.conf.erb'),
        order   => $tomcatOrder,
      }
    }
    if $proxyThin {
      concat::fragment { "vhost_35-proxy_thin_${name}":
        target  => "/etc/httpd/conf.d/${order}-${filename_real}",
        content => template('apache/vhost/35-proxy_thin.conf.erb'),
        order   => 36,
      }
    }
    if !$proxyTomcat and !$proxyThin {
      # TODO - throw error if proxyDest not set
      concat::fragment { "vhost_35-proxy_generic_${name}":
        target  => "/etc/httpd/conf.d/${order}-${filename_real}",
        content => template('apache/vhost/35-proxy_generic.conf.erb'),
        order   => 35,
      }
    }
  }

  if $locations != [] {
    concat::fragment { "vhost_40-locations_${name}":
      target  => "/etc/httpd/conf.d/${order}-${filename_real}",
      content => template('apache/vhost/40-locations.conf.erb'),
      order   => 40,
    }
  }

  if $modSecOverrides {
    concat::fragment { "vhost_45-modsec_${name}":
      target  => "/etc/httpd/conf.d/${order}-${filename_real}",
      content => template('apache/vhost/45-modsec.conf.erb'),
      order   => 45,
    }
  }

  if $headers != '' {
    concat::fragment { "vhost_50-header_${name}":
      target  => "/etc/httpd/conf.d/${order}-${filename_real}",
      content => template('apache/vhost/50-header.conf.erb'),
      order   => 50,
    }
  }

  concat::fragment { "vhost_99-_footer_${name}":
    target  => "/etc/httpd/conf.d/${order}-${filename_real}",
    content => template('apache/vhost/99-footer.conf.erb'),
    order   => 99,
  }

  if $logstash {
    beaver::stanza { "/var/log/httpd/${name_real}_access.json":
      type   => 'apache',
      tags   => ['access', $name, $::disposition],
      format => 'rawjson',
    }

    logrotate::file { "apache_${name_real}":
      log        => "/var/log/httpd/${name_real}_access.json",
      options    => [ 'missingok', 'notifempty', 'create 0644 apache apache', 'sharedscripts', 'weekly' ],
      postrotate => [ '/sbin/service httpd reload > /dev/null 2>/dev/null || true' ]
    }
  }
}
