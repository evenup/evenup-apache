require 'spec_helper'
 
describe 'apache::userdir', :type => :class do

  it { should create_class('apache::userdir') }
  it { should contain_apache__cfgfile('userdir') }

end
