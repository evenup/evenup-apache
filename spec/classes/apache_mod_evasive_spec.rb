require 'spec_helper'

describe 'apache', :type => :class do

  context 'mod_evasive' do
      it { should create_class('apache::mod_evasive') }

    context 'default' do
      it { should contain_package('mod_evasive').with(:ensure => 'latest') }
      it { should contain_apache__cfgfile('mod_evasive.conf') }
    end

    context 'version' do
      let(:params) { { :mod_evasive_version => '1.2.3' } }
      it { should contain_package('mod_evasive').with(:ensure => '1.2.3') }
    end

    context 'absent' do
      let(:params) { { :mod_evasive => false } }
      it { should contain_package('mod_evasive').with(:ensure => 'absent') }
      it { should contain_apache__cfgfile('mod_evasive.conf').with(:ensure => 'absent') }
    end
  end

end
