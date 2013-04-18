require 'rubygems'
require 'puppetlabs_spec_helper/module_spec_helper'
require 'hiera-puppet-helper'

fixture_path = File.expand_path(File.join(__FILE__, '..', 'fixtures'))

shared_context "hieradata" do
  let(:hiera_config) do
    { :backends => ['rspec', 'yaml'],
      :hierarchy => [
        '%{fqdn}/%{calling_module}',
        '%{calling_module}',
        'default'],
      :yaml => {
        :datadir => File.join(fixture_path, 'hieradata') },
      :rspec => respond_to?(:hiera_data) ? hiera_data : {} }
  end
end