require 'spec_helper'

describe 'apache', :type => :class do

  it { should create_class('apache') }
  it { should contain_class('apache::mod_evasive') }
  it { should contain_class('apache::mod_security') }
  it { should contain_class('apache::status') }

end
