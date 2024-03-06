# frozen_string_literal: true

require 'English'
Puppet::Type.type(:cpanm).provide(:default) do
  desc 'Manage CPAN modules with cpanm'

  commands cpanm: 'cpanm'
  commands perl: 'perl'
  commands perldoc: 'perldoc'

  # Override the `commands`-generated cpanm method to avoid resetting locale to 'C'
  # Avoids triggering an old Encode bug in MakeMakeFiles for some modules
  def cpanm(*args)
    result = `cpanm #{args.join ' '}`
    raise Puppet::ExecutionFailure, result if $CHILD_STATUS != 0

    result
  end

  def latest?
    begin
      name = @resource[:name]
      name = name.split('@')[0]
      installed = `perl -e 'require Module::Metadata; $meta = Module::Metadata->new_from_module("#{name}"); if ($meta) {print $meta->version} else {exit 1}'`
    rescue Puppet::ExecutionFailure
      installed = ''
    end
    options = []
    if @resource[:mirror]
      options << '--from'
      options << @resource[:mirror]
    end
    options << '--info'
    options << @resource[:name]

    cpan = cpanm(options).split("\n")[-1].match(%r{([0-9]+\.?[0-9]*).tar.gz})
    if cpan
      latest = cpan[1]
      Puppet.debug("Installed: #{installed}, CPAN: #{latest}")
      return false if latest > installed
    end
    true
  end

  def create
    options = []

    if @resource[:mirror]
      options << '--from'
      options << @resource[:mirror]
    end

    options << '-f' if @resource[:force] == :true || @resource[:force] == true

    options << '-n' if @resource[:test] == :false || @resource[:test] == false

    options << @resource[:name]

    cpanm(options)
  end

  #  alias update create
  def destroy
    cpanm '-U', '-f', @resource[:name]
  rescue Puppet::ExecutionFailure
    # error = Puppet::Error.new("Failed to remove CPAN package: #{e}")
    # error.set_backtrace(e.backtrace)
    # raise error
  end

  def exists?
    name = @resource[:name]
    name, version = name.split('@')
    installed = `perl -e 'require Module::Metadata; $meta = Module::Metadata->new_from_module("#{name}"); if ($meta) {print $meta->version} else {exit 1}'`
    raise Puppet::ExecutionFailure, installed if $CHILD_STATUS != 0

    if !version.nil? && !version.empty?
      if installed.eql? version
        Puppet.debug("Debugging message - versions of #{name} are identical: installed:#{installed} vs requested:#{version}")
        true
      else
        Puppet.debug("Debugging message - versions of #{name} are different: installed:#{installed} vs requested:#{version}")
        false
      end
    else
      true
    end
  rescue Puppet::ExecutionFailure
    false
  end

  def self.instances
    modules = {}
    name = nil
    perldoc('-tT', 'perllocal').split("\n").each do |r|
      if r.include?('"Module"')
        name = r.split[-1]
        modules[name] = new(name: name)
      end
      if r.include?('VERSION: ') && name
        r.split[-1].delete('"')
        # modules[name].version = version
      end
    end
    modules.map { |_k, v| v }
  end
end
