require 'spec_helper'
 
describe 'apache::securefile', :type => :define do
  
  context "when called with source => 'puppet:///modules/apache/test.sec', filename => 'test.secure'" do
    let(:params) { { :content => 'puppet:///modules/apache/test.sec', :filename => 'test.secure' } }
    
    it { should contain_file('/etc/httpd/conf.d/test.secure').with(
      'ensure'  => 'present',
      'source' => 'puppet:///modules/apache/test.sec'
    ) }
  end

  context "when called with source => 'puppet:///modules/apache/test.sec', filename => 'test.secure', ensure => 'absent'" do
    let(:params) { { :content => 'puppet:///modules/apache/test.sec', :filename => 'test.secure', :ensure => 'absent' } }
    
    it { should contain_file('/etc/httpd/conf.d/test.secure').with(
      'ensure'  => 'absent',
      'source' => 'puppet:///modules/apache/test.sec'
    ) }
  end

end
