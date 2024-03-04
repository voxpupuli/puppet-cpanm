# frozen_string_literal: true

require 'spec_helper_acceptance'

describe 'cpanm type' do
  before(:all) do
    pp = <<-EOS
    class { 'cpanm': }
    EOS

    # Run it twice and test for idempotency
    apply_manifest(pp, catch_failures: true)
  end

  describe 'adding CPAN module' do
    it 'works with no errors' do
      pp = <<-EOS
      cpanm { 'YAML': }
      EOS

      # Run it twice and test for idempotency
      apply_manifest(pp, catch_failures: true)
      apply_manifest(pp, catch_changes: true)
    end
  end

  describe 'add CPAN module with tests' do
    it 'works with no errors' do
      pp = <<-EOS
      cpanm { 'JSON':
        test => true,
      }
      EOS

      # Run it twice and test for idempotency
      apply_manifest(pp, catch_failures: true)
      apply_manifest(pp, catch_changes: true)
    end
  end

  describe 'removing CPAN modules' do
    it 'works with no errors' do
      pp = <<-EOS
      cpanm { ['YAML', 'JSON']:
        ensure => absent,
      }
      EOS

      # Run it twice and test for idempotency
      apply_manifest(pp, catch_failures: true)
      apply_manifest(pp, catch_changes: true)
    end
  end
end
