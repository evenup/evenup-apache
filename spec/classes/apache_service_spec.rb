require 'spec_helper'

describe 'apache', :type => :class do

  context 'service' do
    context 'default' do
      it { should contain_service('httpd').with(
        'ensure'  => 'running',
        'enable'  => true
      ) }

      it { should_not contain_class('apache::monitoring::sensu') }
    end

    context 'monitoring::sensu' do
      let(:params) { { :monitoring => 'sensu' } }

      it { should contain_class('apache::monitoring::sensu') }
    end
  end

end
