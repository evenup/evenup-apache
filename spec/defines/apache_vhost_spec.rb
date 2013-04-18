require 'spec_helper'

describe 'apache::vhost', :type => :define do
  let(:title) { 'test_vhost' }
  let(:facts) { { :concat_basedir => '/var/lib/puppet/concat' } }
#  let(:params) { { :serverName => 'server' } }

  context "when using default parameters" do
    let(:params) { { :serverName => 'testname' } }

    it { should_not contain_concat__fragment('vhost_10-redirect_http_test_vhost') }
    it { should_not contain_concat__fragment('vhost_15-ssl_test_vhost') }
    it { should_not contain_concat__fragment('vhost_20-aliases_test_vhost') }
    it { should_not contain_concat__fragment('vhost_25-site_directives_test_vhost') }
    it { should_not contain_concat__fragment('vhost_30-docroot_test_vhost') }
    it { should_not contain_concat__fragment('vhost_35-proxy_tomcat_test_vhost') }
    it { should_not contain_concat__fragment('vhost_35-proxy_thin_test_vhost') }
    it { should_not contain_concat__fragment('vhost_35-proxy_generic_test_vhost') }
    it { should_not contain_concat__fragment('vhost_40-locations_test_vhost') }
    it { should contain_apache__namevhost('80') }
  end

  context "when using default vhost header information" do
    let(:params) { { :serverName => 'someserver.example.org' } }
    it { should contain_concat('/etc/httpd/conf.d/99-test_vhost.conf') }
    it { should contain_concat__fragment('vhost_01-header_test_vhost') }
    subject { concat__fragment('vhost_01-header_test_vhost') }
    it { should contain_concat__fragment('vhost_01-header_test_vhost').with_content(/^<VirtualHost \*:80>$/) }
    it { should contain_concat__fragment('vhost_01-header_test_vhost').with_content(/^\s+ServerName someserver.example.org$/) }
    it { should contain_concat__fragment('vhost_01-header_test_vhost').with_content(/^\s+ServerAdmin admin@letsevenup.com$/) }
    it { should contain_concat__fragment('vhost_01-header_test_vhost').with_content(/^\s+CustomLog \/var\/log\/httpd\/test_vhost_access_proxied.log proxied env=is_forwarded$/) }
    it { should contain_concat__fragment('vhost_01-header_test_vhost').with_content(/^\s+CustomLog \/var\/log\/httpd\/test_vhost_access_direct.log direct env=!is_forwarded$/) }
    it { should contain_concat__fragment('vhost_01-header_test_vhost').with_content(/^\s+LogLevel warn$/) }
  end

  context "when setting vhost header information" do
    context "using correct parameters (string for serverAlias)" do
      let(:params) { {
        :port         => '8080',
        :serverName   => 'someserver.example.org',
        :serverAlias  => 'name1.example.org',
        :log_level    => 'crit',
        :serverAdmin  => 'someone@example.org',
        :order        => '10'
      } }

      it { should contain_apache__namevhost('8080') }
      it { should contain_concat('/etc/httpd/conf.d/10-test_vhost.conf') }
      it { should contain_concat__fragment('vhost_01-header_test_vhost') }
      it { should contain_concat__fragment('vhost_01-header_test_vhost').with_content(/^<VirtualHost \*:8080>$/) }
      it { should contain_concat__fragment('vhost_01-header_test_vhost').with_content(/^\s+ServerName someserver.example.org$/) }
      it { should contain_concat__fragment('vhost_01-header_test_vhost').with_content(/^\s+ServerAlias name1.example.org/) }
      it { should contain_concat__fragment('vhost_01-header_test_vhost').with_content(/^\s+ServerAdmin someone@example.org$/) }
      it { should contain_concat__fragment('vhost_01-header_test_vhost').with_content(/^\s+CustomLog \/var\/log\/httpd\/test_vhost_access_proxied.log proxied env=is_forwarded$/) }
      it { should contain_concat__fragment('vhost_01-header_test_vhost').with_content(/^\s+CustomLog \/var\/log\/httpd\/test_vhost_access_direct.log direct env=!is_forwarded$/) }
      it { should contain_concat__fragment('vhost_01-header_test_vhost').with_content(/^\s+LogLevel crit$/) }
    end

    context "using correct parameters (array for serverAlias)" do
      let(:params) { { :serverName => 'testname', :serverAlias  => [ 'name1.example.org', 'name2.example.org' ] } }
      it { should contain_concat__fragment('vhost_01-header_test_vhost').with_content(/^\s+ServerAlias name1.example.org name2.example.org/) }
    end
  end

  context "when redirecting http to https" do
    context "using the default ports" do
      let(:params) { { :redirectToHTTPS => true, :serverName => 'testname' } }
      it { should contain_concat__fragment('vhost_10-redirect_http_test_vhost') }
      it { should contain_concat__fragment('vhost_10-redirect_http_test_vhost').with_content(/^\s+RewriteRule \^\/\?\(\.\*\) https:\/\/\%\{SERVER_NAME\}\/\$1 \[R,L\]/) }
    end

    context "defining targetPort" do
      let(:params) { { :redirectToHTTPS => true, :serverName => 'testname', :targetPort => '8443' } }
      it { should contain_concat__fragment('vhost_10-redirect_http_test_vhost') }
      it { should contain_concat__fragment('vhost_10-redirect_http_test_vhost').with_content(/^\s+RewriteRule \^\/\?\(\.\*\) https:\/\/\%\{SERVER_NAME\}:8443\/\$1 \[R,L\]/) }
    end
  end

  context "enabling ssl" do
    let(:params) { { :serverName => 'testname', :ssl => true, :sslCert => 'certname', :sslChainFile => 'gd_bundle' } }

    it { should contain_concat__fragment('vhost_15-ssl_test_vhost') }
    it { should contain_concat__fragment('vhost_15-ssl_test_vhost').with_content(/^\s+SSLCertificateFile \/etc\/httpd\/secure\/certname\.crt$/) }
    it { should contain_concat__fragment('vhost_15-ssl_test_vhost').with_content(/^\s+SSLCertificateKeyFile \/etc\/httpd\/secure\/certname\.key$/) }
    it { should contain_concat__fragment('vhost_15-ssl_test_vhost').with_content(/^\s+SSLCertificateChainFile \/etc\/httpd\/secure\/gd_bundle\.crt$/) }
  end

  context "when using aliases" do
    context "as strings" do
      let(:params) { { :serverName => 'testName', :aliases => '/blah /blah2', :scriptAliases => '/blah3 /blah4' } }

      it { should contain_concat__fragment('vhost_20-aliases_test_vhost') }
      it { should contain_concat__fragment('vhost_20-aliases_test_vhost').with_content(/^\s+Alias \/blah \/blah2$/) }
      it { should contain_concat__fragment('vhost_20-aliases_test_vhost').with_content(/^\s+ ScriptAlias \/blah3 \/blah4$/) }
    end

    context "as arrays" do
      let(:params) { { :serverName => 'testName', :aliases => [ '/blah /blah2', '/blah3 /blah4' ], :scriptAliases => [ '/blah5 /blah6', '/blah7 /blah8'] } }

      it { should contain_concat__fragment('vhost_20-aliases_test_vhost') }
      it { should contain_concat__fragment('vhost_20-aliases_test_vhost').with_content(/^\s+Alias \/blah \/blah2\n\s+Alias \/blah3 \/blah4$/) }
      it { should contain_concat__fragment('vhost_20-aliases_test_vhost').with_content(/^\s+ ScriptAlias \/blah5 \/blah6\n\s+ScriptAlias \/blah7 \/blah8$/) }
    end
  end

  context "when using site directives" do
    context "as a string" do
      let(:params) { { :serverName => 'testName', :siteDirectives => 'WSGIApplicationGroup %{GLOBAL}' } }

      it { should contain_concat__fragment('vhost_25-site_directives_test_vhost') }
      it { should contain_concat__fragment('vhost_25-site_directives_test_vhost').with_content(/^\s+WSGIApplicationGroup \%\{GLOBAL\}$/) }
    end

    context "as an array" do
      let(:params) { { :serverName => 'testName', :siteDirectives => [ 'WSGIApplicationGroup %{GLOBAL}', 'WSGIProcessGroup graphite' ] } }

      it { should contain_concat__fragment('vhost_25-site_directives_test_vhost') }
      it { should contain_concat__fragment('vhost_25-site_directives_test_vhost').with_content(/^\s+WSGIApplicationGroup \%\{GLOBAL\}$/) }
      it { should contain_concat__fragment('vhost_25-site_directives_test_vhost').with_content(/^\s+WSGIProcessGroup graphite$/) }

    end
  end

  context "when setting up a standard site" do
    let(:params) { { :serverName => 'testName', :docroot => '/var/somewhere' } }

    it { should contain_concat__fragment('vhost_30-docroot_test_vhost') }
    it { should contain_concat__fragment('vhost_30-docroot_test_vhost').with_content(/^\s+DocumentRoot \/var\/somewhere$/) }
    it { should contain_concat__fragment('vhost_30-docroot_test_vhost').with_content(/^\s+<Directory \"\/var\/somewhere\">$/) }
    it { should_not contain_concat__fragment('vhost_30-docroot_test_vhost').with_content(/^\sOptions/) }
    it { should_not contain_concat__fragment('vhost_30-docroot_test_vhost').with_content(/^\sAddHandler/) }
    it { should_not contain_concat__fragment('vhost_30-docroot_test_vhost').with_content(/^\sDirectoryIndex/) }
    it { should_not contain_concat__fragment('vhost_30-docroot_test_vhost').with_content(/^\sDeny from all/) }

    context "using options" do
      context "as an array" do
        let(:params) { { :serverName => 'testName', :docroot => '/var/somewhere', :options => 'FollowSymlinks Indexes' } }

        it { should contain_concat__fragment('vhost_30-docroot_test_vhost').with_content(/^\s+Options\s+FollowSymlinks Indexes$/) }
      end

      context "as a string" do
        let(:params) { { :serverName => 'testName', :docroot => '/var/somewhere', :options => [ 'FollowSymlinks',  'Indexes' ] } }

        it { should contain_concat__fragment('vhost_30-docroot_test_vhost').with_content(/^\s+Options\s+FollowSymlinks Indexes$/) }
      end
    end

    context "using AddHandler" do
      let(:params) { { :serverName => 'testName', :docroot => '/var/somewhere', :addHandler => 'cgi-script .cgi' } }

      it { should contain_concat__fragment('vhost_30-docroot_test_vhost').with_content(/^\s+AddHandler cgi-script .cgi$/) }
    end

    context "specifying a directory index" do
      let(:params) { { :serverName => 'testName', :docroot => '/var/somewhere', :directoryIndex => 'index.php' } }

      it { should contain_concat__fragment('vhost_30-docroot_test_vhost').with_content(/^\s+DirectoryIndex index.php$/) }
    end

    context "using basic auth" do
      let(:params) { { :serverName => 'testName', :docroot => '/var/somewhere', :auth => true, :authParams => ['Require valid-user', 'AuthType basic', 'AuthName "basictest"', 'AuthUserFile /etc/httpd/secure/passwords.passwd' ] } }

      it { should contain_concat__fragment('vhost_30-docroot_test_vhost').with_content(/^\s+Require valid\-user$/) }
      it { should contain_concat__fragment('vhost_30-docroot_test_vhost').with_content(/^\s+AuthType basic$/) }
      it { should contain_concat__fragment('vhost_30-docroot_test_vhost').with_content(/^\s+AuthName "basictest"$/) }
      it { should contain_concat__fragment('vhost_30-docroot_test_vhost').with_content(/^\s+AuthUserFile \/etc\/httpd\/secure\/passwords.passwd$/) }
    end
  end

  context "proxing tomcat" do
    context "using default parameters" do
      let(:params) { { :serverName => 'testName', :proxy => true, :proxyTomcat => true } }

      it { should contain_concat__fragment('vhost_35-proxy_tomcat_test_vhost') }
      it { should contain_concat__fragment('vhost_35-proxy_tomcat_test_vhost').with_content(/^\s+<Location \/>$/) }
      it { should_not contain_concat__fragment('vhost_35-proxy_tomcat_test_vhost').with_content(/^\s+Deny from all$/) }
      it { should contain_concat__fragment('vhost_35-proxy_tomcat_test_vhost').with_content(/^\s+ProxyPass ajp:\/\/localhost:8009\/$/) }
      it { should contain_concat__fragment('vhost_35-proxy_tomcat_test_vhost').with_content(/^\s+ProxyPassReverse ajp:\/\/localhost:8009\/$/) }
    end

    context "using defining parameters" do
      let(:params) { {
        :serverName => 'testName',
        :proxy => true,
        :proxyTomcat => true,
        :proxyUrl => 'testurl',
        :ajpHost => 'testHost',
        :ajpPort => 1234,
        :auth => true,
        :authParams => [ 'Require valid-user', 'AuthType basic' ]
      } }

      it { should contain_concat__fragment('vhost_35-proxy_tomcat_test_vhost') }
      it { should contain_concat__fragment('vhost_35-proxy_tomcat_test_vhost').with_content(/^\s+<Location \/testurl>$/) }
      it { should contain_concat__fragment('vhost_35-proxy_tomcat_test_vhost').with_content(/^\s+Deny from all$/) }
      it { should contain_concat__fragment('vhost_35-proxy_tomcat_test_vhost').with_content(/^\s+Require valid\-user$/) }
      it { should contain_concat__fragment('vhost_35-proxy_tomcat_test_vhost').with_content(/^\s+AuthType basic$/) }
      it { should contain_concat__fragment('vhost_35-proxy_tomcat_test_vhost').with_content(/^\s+ProxyPass ajp:\/\/testHost:1234\/testurl$/) }
      it { should contain_concat__fragment('vhost_35-proxy_tomcat_test_vhost').with_content(/^\s+ProxyPassReverse ajp:\/\/testHost:1234\/testurl$/) }
    end
  end

  context "proxing thin" do
    context "using default parameters" do
      let(:params) { { :serverName => 'testName', :proxy => true, :proxyThin => true } }

      it { should contain_concat__fragment('vhost_35-proxy_thin_test_vhost') }
      it { should contain_concat__fragment('vhost_35-proxy_thin_test_vhost').with_content(/^\s+<Proxy balancer:\/\/test_vhost>$/) }
      it { should contain_concat__fragment('vhost_35-proxy_thin_test_vhost').with_content(/^\s+BalancerMember http:\/\/127\.0\.0\.1:3000$/) }
      it { should contain_concat__fragment('vhost_35-proxy_thin_test_vhost').with_content(/^\s+BalancerMember http:\/\/127\.0\.0\.1:3001$/) }
      it { should contain_concat__fragment('vhost_35-proxy_thin_test_vhost').with_content(/^\s+BalancerMember http:\/\/127\.0\.0\.1:3002$/) }
      it { should contain_concat__fragment('vhost_35-proxy_thin_test_vhost').with_content(/^\s+<Location \/>$/) }
      it { should_not contain_concat__fragment('vhost_35-proxy_thin_test_vhost').with_content(/^\s+Deny from all$/) }
      it { should contain_concat__fragment('vhost_35-proxy_thin_test_vhost').with_content(/^\s+ProxyPass balancer:\/\/test_vhost\/$/) }
      it { should contain_concat__fragment('vhost_35-proxy_thin_test_vhost').with_content(/^\s+ProxyPassReverse balancer:\/\/test_vhost\/$/) }
    end

    context "using defining parameters" do
      let(:params) { {
        :serverName => 'testName',
        :proxy => true,
        :proxyThin => true,
        :proxyUrl => 'testurl',
        :thinPort => 4000,
        :thinNumServers => 2,
        :auth => true,
        :authParams => [ 'Require valid-user', 'AuthType basic' ]
      } }


      it { should contain_concat__fragment('vhost_35-proxy_thin_test_vhost').with_content(/^\s+<Proxy balancer:\/\/test_vhost>$/) }
      it { should contain_concat__fragment('vhost_35-proxy_thin_test_vhost').with_content(/^\s+BalancerMember http:\/\/127\.0\.0\.1:4000$/) }
      it { should contain_concat__fragment('vhost_35-proxy_thin_test_vhost').with_content(/^\s+BalancerMember http:\/\/127\.0\.0\.1:4001$/) }
      it { should contain_concat__fragment('vhost_35-proxy_thin_test_vhost').with_content(/^\s+<Location \/testurl>$/) }
      it { should contain_concat__fragment('vhost_35-proxy_thin_test_vhost').with_content(/^\s+Deny from all$/) }
      it { should contain_concat__fragment('vhost_35-proxy_thin_test_vhost').with_content(/^\s+Require valid\-user$/) }
      it { should contain_concat__fragment('vhost_35-proxy_thin_test_vhost').with_content(/^\s+AuthType basic$/) }
      it { should contain_concat__fragment('vhost_35-proxy_thin_test_vhost').with_content(/^\s+ProxyPass balancer:\/\/test_vhost\/testurl$/) }
      it { should contain_concat__fragment('vhost_35-proxy_thin_test_vhost').with_content(/^\s+ProxyPassReverse balancer:\/\/test_vhost\/$/) }
    end
  end

  context "using generic proxy" do
    context "using minimal parameters" do
      let(:params) { { :serverName => 'testName', :proxy => true, :proxyDest => 'http://somewhere' } }

      it { should contain_concat__fragment('vhost_35-proxy_generic_test_vhost') }
      it { should contain_concat__fragment('vhost_35-proxy_generic_test_vhost').with_content(/\s+ProxyPass\s+\/ http:\/\/somewhere$/) }
      it { should contain_concat__fragment('vhost_35-proxy_generic_test_vhost').with_content(/\s+ProxyPassReverse\s+\/ http:\/\/somewhere$/) }
      it { should contain_concat__fragment('vhost_35-proxy_generic_test_vhost').with_content(/\s+<Location \/>$/) }
      it { should_not contain_concat__fragment('vhost_35-proxy_generic_test_vhost').with_content(/\s+Deny from all$/) }
    end

    context "using all parameters" do
      let(:params) { { :serverName => 'testName', :proxy => true, :proxyUrl => 'here', :proxyDest => 'http://somewhere', :auth => true, :authParams => [ 'Require valid-user', 'AuthType basic' ] } }

      it { should contain_concat__fragment('vhost_35-proxy_generic_test_vhost') }
      it { should contain_concat__fragment('vhost_35-proxy_generic_test_vhost').with_content(/\s+ProxyPass\s+\/here http:\/\/somewhere$/) }
      it { should contain_concat__fragment('vhost_35-proxy_generic_test_vhost').with_content(/\s+ProxyPassReverse\s+\/here http:\/\/somewhere$/) }
      it { should contain_concat__fragment('vhost_35-proxy_generic_test_vhost').with_content(/\s+<Location \/here>$/) }
      it { should contain_concat__fragment('vhost_35-proxy_generic_test_vhost').with_content(/^\s+Deny from all$/) }
      it { should contain_concat__fragment('vhost_35-proxy_generic_test_vhost').with_content(/^\s+Require valid\-user$/) }
      it { should contain_concat__fragment('vhost_35-proxy_generic_test_vhost').with_content(/^\s+AuthType basic$/) }
    end
  end

  context "when configuring additional locations" do
    let(:params) { { :serverName => 'testName', :locations => [{'name' => '/content/', 'params' => ['SetHandler None']}, {'name' => '/media/', 'params' => ['SetHandler None']}] } }

    context it { should contain_concat__fragment('vhost_40-locations_test_vhost') }
    context it { should contain_concat__fragment('vhost_40-locations_test_vhost').with_content(/^\s+<Location \/content\/>$/) }
    context it { should contain_concat__fragment('vhost_40-locations_test_vhost').with_content(/^\s+SetHandler None$/) }
    context it { should contain_concat__fragment('vhost_40-locations_test_vhost').with_content(/^\s+<Location \/media\/>$/) }
    context it { should contain_concat__fragment('vhost_40-locations_test_vhost').with_content(/^\s+SetHandler None$/) }
  end

  context "when defining mod_security overrides" do
    let(:params) { { :serverName => 'testname' } }
    pending "write me"
  end
end
