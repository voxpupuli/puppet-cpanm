require 'spec_helper'
describe 'cpanm' do
  context 'with default values for all parameters' do
    it { should contain_class('cpanm') }
	it { should contain_package('perl') }
	it { should contain_package('gcc') }
	it { should contain_package('make') }
	it { should contain_file('/var/cache/cpanm-install')
	  .with_source('puppet:///modules/cpanm/cpanm')
	}
	it { should contain_exec('/usr/bin/perl /var/cache/cpanm-install -n App::cpanminus') }
  end
end
