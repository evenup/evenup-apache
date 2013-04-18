require 'spec_helper'
 
describe 'apache::cfgfile', :type => :define do
  let(:title) { 'mycfg' }

  context "when called with content => 'test', filename => 'mycfg.cfg'" do
    let(:params) { { :content => 'test', :filename => 'mycfg.cfg' } }
    
    it { should contain_file('/etc/httpd/conf.d/00-mycfg.cfg').with(
      'ensure'  => 'present',
      'content' => 'test'
    ) }
  end

  context "when called with content => 'test', filename => 'mycfg.cfg', ensure => 'absent'" do
    let(:params) { { :content => 'test', :filename => 'mycfg.cfg', :ensure => 'absent' } }
    
    it { should contain_file('/etc/httpd/conf.d/00-mycfg.cfg').with(
      'ensure'  => 'present',
      'content' => 'test',
      'ensure'  => 'absent'
    ) }
  end

  context "when called with content => 'test', filename => 'mycfg.cfg', order => '10" do
    let(:params) { { :content => 'test', :filename => 'mycfg.cfg', :order => '10' } }
    
    it { should contain_file('/etc/httpd/conf.d/10-mycfg.cfg').with(
      'ensure'  => 'present',
      'content' => 'test'
    ) }
  end
end
