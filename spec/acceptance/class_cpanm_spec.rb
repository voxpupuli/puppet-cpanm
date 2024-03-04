# frozen_string_literal: true

require 'spec_helper_acceptance'

describe 'cpanm class' do
  it 'works with no errors' do
    pp = <<-EOS
    class { 'cpanm': }
    EOS

    # Run it twice and test for idempotency
    apply_manifest(pp, catch_failures: true)
    apply_manifest(pp, catch_changes: true)
  end
end
