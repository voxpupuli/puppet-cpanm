# frozen_string_literal: true

require 'spec_helper'

# Whether the module is expected to add the 'perl-core' package for the
# given facts: only RedHat-family OSes with a major release older than 8.
def expects_perl_core?(facts)
  facts[:os]['family'] == 'RedHat' && Gem::Version.new(facts[:os]['release']['major']) < Gem::Version.new('8')
end

describe 'cpanm' do
  on_supported_os.each do |os, facts|
    context "on #{os}" do
      let :facts do
        facts
      end

      context 'with default parameters' do
        it { is_expected.to contain_class('cpanm') }
        it { is_expected.to contain_package('perl') }
        it { is_expected.to contain_package('gcc') }
        it { is_expected.to contain_package('make') }

        if expects_perl_core?(facts)
          it { is_expected.to contain_package('perl-core') }
        else
          it { is_expected.not_to contain_package('perl-core') }
        end
        it { is_expected.to contain_exec('install cpanminus').with_command('/usr/bin/curl -L https://cpanmin.us | /usr/bin/perl -  -n App::cpanminus ') }
      end

      context 'with installer, mirror and lwpbootstraparg' do
        let(:params) do
          {
            installer: 'https://cpanmin.localdomain',
            mirror: 'http://mirror.test.anywhere/cpan/',
            lwpbootstraparg: true,
          }
        end
        let(:facts) do
          {
            os: {
              family: 'Debian',
            },
          }
        end

        it {
          is_expected.to contain_class('cpanm')
            .with_installer('https://cpanmin.localdomain')
            .with_mirror('http://mirror.test.anywhere/cpan/')
            .with_lwpbootstraparg(true)
        }

        it { is_expected.to contain_package('perl') }
        it { is_expected.to contain_package('gcc') }
        it { is_expected.to contain_package('make') }

        if ['RedHat'].include?(facts[:os][:family]) && ['7'].include?(facts[:os]['release']['major'])
          it { is_expected.to contain_package('perl-core') }
        else
          it { is_expected.not_to contain_package('perl-core') }
        end

        it {
          is_expected.to contain_exec('install cpanminus')
            .with_command('/usr/bin/curl -L https://cpanmin.localdomain | /usr/bin/perl - --from http://mirror.test.anywhere/cpan/ -n App::cpanminus --no-lwp')
        }
      end
    end
  end

  # Explicitly parametrized RedHat-family major release versions, including
  # ones not (yet) present in metadata.json's operatingsystem_support. This
  # guards against regressions in the major-version comparison logic, such
  # as incorrectly using string comparison (e.g. '10' < '8' is true
  # lexicographically, but false numerically).
  context 'across RedHat-family major releases' do
    [
      { major: '6', perl_core: true },
      { major: '7', perl_core: true },
      { major: '8', perl_core: false },
      { major: '9', perl_core: false },
      { major: '10', perl_core: false },
      { major: '11', perl_core: false },
    ].each do |testcase|
      context "on RedHat with major release '#{testcase[:major]}'" do
        let(:facts) do
          {
            os: {
              family: 'RedHat',
              name: 'CentOS',
              release: {
                major: testcase[:major],
                full: "#{testcase[:major]}.0",
              },
            },
            kernel: 'Linux',
            osfamily: 'RedHat',
          }
        end

        it { is_expected.to compile.with_all_deps }
        it { is_expected.to contain_package('perl') }
        it { is_expected.to contain_package('gcc') }
        it { is_expected.to contain_package('make') }

        if testcase[:perl_core]
          it { is_expected.to contain_package('perl-core') }
        else
          it { is_expected.not_to contain_package('perl-core') }
        end
      end
    end
  end
end
