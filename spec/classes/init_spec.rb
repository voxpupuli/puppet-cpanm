require 'spec_helper'
describe 'cpanm' do
  context 'with default values for all parameters' do
    it { should contain_class('cpanm') }
  end
end
