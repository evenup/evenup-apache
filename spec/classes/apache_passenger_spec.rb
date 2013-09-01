require 'spec_helper'
 
describe 'apache::passenger', :type => :class do

  it { should create_class('apache::passenger') }
  it { should include_class('ruby::rack') }
  it { should contain_package('mod_passenger') }
  it { should contain_apache__cfgfile('passenger') }

end
