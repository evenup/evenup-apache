require 'spec_helper'

describe 'apache::service', :type => :class do
  include_context "hieradata"

  it { should contain_service('httpd').with(
    'ensure'  => 'running',
    'enable'  => true
  ) }

  context 'monitoring::sensu' do
    let(:hiera_facts) { { :monitoring => 'sensu' } }

    it { should include_class('apache::monitoring::sensu') }
  end

end
