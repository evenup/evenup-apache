require 'spec_helper'

describe 'apache', :type => :class do

  it { should create_class('apache::install') }

  context 'install' do
    context 'default' do
      it { should contain_package('httpd').with_ensure('latest') }

      it { should contain_file('/etc/httpd/conf/httpd.conf') }
      it { should contain_file('/etc/httpd/conf.d/').with(
        'ensure'  => 'directory',
        'purge'   => true,
        'recurse' => true,
        'force'   => true
      ) }
      it { should contain_file('/var/log/httpd/') }
    end

    context '#ensure' do
      let(:params) { { :ensure => '2.3.4' } }
      it { should contain_package('httpd').with_ensure('2.3.4') }
    end
  end

end
