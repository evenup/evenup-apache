require 'spec_helper'

describe 'apache', :type => :class do

  it { should create_class('apache') }
  it { should include_class('apache::mod_evasive') }
  it { should include_class('apache::mod_security') }
  it { should include_class('apache::status') }
  
end
