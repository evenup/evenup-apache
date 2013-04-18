require 'spec_helper'
 
describe 'apache::ssl', :type => :class do

  it { should create_class('apache::ssl') }
  it { should contain_package('mod_ssl') }
  it { should contain_apache__cfgfile('ssl.conf') }
  it { should contain_file('/etc/httpd/secure/').with(
    'ensure'  => 'directory',
    'owner'   => 'apache',
    'group'   => 'wheel',
    'mode'    => '0550'
  ) }

end
