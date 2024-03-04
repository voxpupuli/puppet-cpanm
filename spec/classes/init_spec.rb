# frozen_string_literal: true

require 'spec_helper'

describe 'cpanm' do
  context 'on Debian with default parameters' do
    let(:facts) do
      {
        os: {
          family: 'Debian',
        }
      }
    end

    it { is_expected.to contain_class('cpanm') }
    it { is_expected.to contain_package('perl') }
    it { is_expected.to contain_package('gcc') }
    it { is_expected.to contain_package('make') }
    it { is_expected.not_to contain_package('perl-core') }

    it {
      is_expected.to contain_exec('install cpanminus').
        with_command('/usr/bin/curl -L https://cpanmin.us | /usr/bin/perl -  -n App::cpanminus ')
    }
  end

  context 'on Debian with installer, mirror and lwpbootstraparg' do
    let(:params) do
      {
        installer: 'https://cpanmin.localdomain',
        mirror: 'http://mirror.test.anywhere/cpan/',
        lwpbootstraparg: true
      }
    end
    let(:facts) do
      {
        os: {
          family: 'Debian',
        }
      }
    end

    it {
      is_expected.to contain_class('cpanm').
        with_installer('https://cpanmin.localdomain').
        with_mirror('http://mirror.test.anywhere/cpan/').
        with_lwpbootstraparg(true)
    }

    it { is_expected.to contain_package('perl') }
    it { is_expected.to contain_package('gcc') }
    it { is_expected.to contain_package('make') }
    it { is_expected.not_to contain_package('perl-core') }

    it {
      is_expected.to contain_exec('install cpanminus').
        with_command('/usr/bin/curl -L https://cpanmin.localdomain | /usr/bin/perl - --from http://mirror.test.anywhere/cpan/ -n App::cpanminus --no-lwp')
    }
  end

  context 'on RHEL7 with default parameters' do
    let(:facts) do
      {
        os: {
          family: 'RedHat',
        }
      }
    end

    it { is_expected.to contain_class('cpanm') }
    it { is_expected.to contain_package('perl') }
    it { is_expected.to contain_package('gcc') }
    it { is_expected.to contain_package('make') }
    it { is_expected.to contain_package('perl-core') }

    it {
      is_expected.to contain_exec('install cpanminus').
        with_command('/usr/bin/curl -L https://cpanmin.us | /usr/bin/perl -  -n App::cpanminus ')
    }
  end

  context 'on RHEL7 with installer, mirror and lwpbootstraparg' do
    let(:params) do
      {
        installer: 'https://cpanmin.localdomain',
        mirror: 'http://mirror.test.anywhere/cpan/',
        lwpbootstraparg: true
      }
    end
    let(:facts) do
      {
        os: {
          family: 'RedHat',
        }
      }
    end

    it {
      is_expected.to contain_class('cpanm').
        with_installer('https://cpanmin.localdomain').
        with_mirror('http://mirror.test.anywhere/cpan/').
        with_lwpbootstraparg(true)
    }

    it { is_expected.to contain_package('perl') }
    it { is_expected.to contain_package('gcc') }
    it { is_expected.to contain_package('make') }
    it { is_expected.to contain_package('perl-core') }

    it {
      is_expected.to contain_exec('install cpanminus').
        with_command('/usr/bin/curl -L https://cpanmin.localdomain | /usr/bin/perl - --from http://mirror.test.anywhere/cpan/ -n App::cpanminus --no-lwp')
    }
  end
end
