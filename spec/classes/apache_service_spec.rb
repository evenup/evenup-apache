require 'spec_helper'

describe 'apache::service', :type => :class do

  context 'default' do
    it { should contain_service('httpd').with(
      'ensure'  => 'running',
      'enable'  => true
    ) }

    it { should_not include_class('apache::monitoring::sensu') }
  end

  context 'monitoring::sensu' do
    let(:params) { { :monitoring => 'sensu' } }

    it { should include_class('apache::monitoring::sensu') }
  end

end
