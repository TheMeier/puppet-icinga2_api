require 'spec_helper'
describe 'icinga2api' do
  context 'with default values for all parameters' do
    it { should contain_class('icinga2api') }
  end
end
