require 'spec_helper'

describe 'apache::mod_deflate', :type => :class do

  it { should create_class('apache::mod_deflate') }
  it { should contain_apache__cfgfile('mod_deflate.conf') }

end
