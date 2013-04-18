require 'spec_helper'
 
describe 'apache::wsgi', :type => :class do

  it { should create_class('apache::wsgi') }
  it { should contain_package('mod_wsgi') }
  it { should contain_apache__cfgfile('wsgi') }
  it { should contain_file('/var/run/wsgi').with(
    'ensure'  => 'directory',
    'owner'   => 'apache',
    'group'   => 'apache',
    'mode'    => '0770'
  ) }

end
