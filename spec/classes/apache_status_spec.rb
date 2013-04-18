require 'spec_helper'
 
describe 'apache::status', :type => :class do

  it { should create_class('apache::status') }
  it { should contain_apache__cfgfile('status') }

end
