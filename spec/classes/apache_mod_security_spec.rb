require 'spec_helper'

describe 'apache::mod_security', :type => :class do

  it { should create_class('apache::mod_security') }

  context "when $ensure = present" do
    let(:params) { { :ensure => true } }

    it { should contain_package('mod_security').with('ensure' => 'latest') }
    it { should contain_apache__cfgfile('mod_security.conf').with('ensure' => 'present') }
    it { should contain_file('/etc/httpd/modsecurity.d/').with(
      'ensure'  => 'directory',
      'source'  => 'puppet:///modules/apache/mod_security.d'
    ) }
  end

  context "when $ensure = absent" do
    let(:params) { { :ensure => false } }

    it { should contain_package('mod_security').with('ensure' => 'absent') }
    it { should contain_apache__cfgfile('mod_security.conf').with('ensure' => 'absent') }
    it { should contain_file('/etc/httpd/modsecurity.d/').with_ensure('absent') }
  end

end
