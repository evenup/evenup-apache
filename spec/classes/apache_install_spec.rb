require 'spec_helper'

describe 'apache::install', :type => :class do

  it { should create_class('apache::install') }
  it { should include_class('logrotate') }

  it { should contain_package('httpd') }

  it { should contain_file('/etc/httpd/conf/httpd.conf') }
  it { should contain_file('/etc/httpd/conf.d/').with(
    'ensure'  => 'directory',
    'purge'   => true,
    'recurse' => true,
    'force'   => true
  ) }
  it { should contain_file('/var/log/httpd/') }

  it { should contain_logrotate__file('httpd') }

end
