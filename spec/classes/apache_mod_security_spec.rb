require 'spec_helper'

describe 'apache' do

  context 'mod_security' do

    it { should contain_class('apache::mod_security') }

    context "default" do

      it { should contain_package('mod_security').with(:ensure => 'latest') }
      it { should contain_package('mod_security_crs').with(:ensure => 'latest') }
      it { should contain_apache__cfgfile('mod_security.conf').with(:ensure => 'present') }
      it { should contain_file('/etc/httpd/modsecurity.d/modsecurity_crs_10_config.conf').with(
        :content  => /setvar:'tx\.allowed_request_content_type=application\/x\-www\-form\-urlencoded\|multipart\/form\-data\|text\/xml\|application\/xml\|application\/x\-amf',/
      ) }

      # spot check a few default rules
      it { should contain_file('modsecurity_35_scanners.data').with(
        :path   => '/etc/httpd/modsecurity.d/activated_rules/modsecurity_35_scanners.data',
        :target => '/usr/lib/modsecurity.d/base_rules/modsecurity_35_scanners.data'
      ) }
      it { should contain_file('modsecurity_crs_49_inbound_blocking.conf').with(
        :path   => '/etc/httpd/modsecurity.d/activated_rules/modsecurity_crs_49_inbound_blocking.conf',
        :target => '/usr/lib/modsecurity.d/base_rules/modsecurity_crs_49_inbound_blocking.conf'
      ) }
    end

    context 'set package versions' do
      let(:params) { { :modsec_version => '1.2.3', :modsec_crs_version => '2.3.4' } }
      it { should contain_package('mod_security').with(:ensure => '1.2.3') }
      it { should contain_package('mod_security_crs').with(:ensure => '2.3.4') }
    end

    context 'allow setting modsec rules' do
      let(:params) { { :activate_rules  => 'myrule.conf' } }

      it { should contain_file('myrule.conf').with(
        :path   => '/etc/httpd/modsecurity.d/activated_rules/myrule.conf',
        :target => '/usr/lib/modsecurity.d/base_rules/myrule.conf'
      ) }

      it { should_not contain_file('modsecurity_crs_49_inbound_blocking.conf') }
    end

    context 'setting modsec protocols' do
      let(:params) { { :modsec_protocols => 'application/x-www-form-urlencoded' } }
      it { should contain_file('/etc/httpd/modsecurity.d/modsecurity_crs_10_config.conf').with(
        :content  => /setvar:'tx\.allowed_request_content_type=application\/x\-www\-form\-urlencoded',/
      ) }
    end

    context "when $mod_sec = false" do
      let(:params) { { :mod_sec => false } }

      it { should contain_package('mod_security').with('ensure' => 'absent') }
      it { should contain_apache__cfgfile('mod_security.conf').with('ensure' => 'absent') }
      it { should contain_file('/etc/httpd/modsecurity.d/').with_ensure('absent') }
    end

  end
end
