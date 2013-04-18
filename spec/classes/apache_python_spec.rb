require 'spec_helper'
 
describe 'apache::python', :type => :class do

  it { should create_class('apache::python') }
  it { should contain_package('mod_python') }
  it { should contain_apache__cfgfile('python') }

end
