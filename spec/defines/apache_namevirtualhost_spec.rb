require 'spec_helper'

describe 'apache::namevhost', :type => :define do
  let(:title) { '80' }

  it { should contain_apache__cfgfile('name-vhost-80').with(
    'content' => "#Managed by puppet - do not modify\nListen 80\nNameVirtualHost *:80\n"
  )}

end
