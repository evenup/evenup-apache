require 'spec_helper'

describe 'apache::mod_evasive', :type => :class do

  it { should create_class('apache::mod_evasive') }
  it { should contain_package('mod_evasive') }
  it { should contain_apache__cfgfile('mod_evasive.conf') }

end
