Puppet::Type.type(:cpanm).provide(:default) do
  desc 'Manage CPAN modules with cpanm'

  commands :cpanm => 'cpanm'
  commands :perl => 'perl'
  commands :perldoc => 'perldoc'

  # add a method to check if an object is a number
  class Object
    def is_number?
      to_f.to_s == to_s || to_i.to_s == to_s
    end
  end

  # Override the `commands`-generated cpanm method to avoid resetting locale to 'C'
  # Avoids triggering an old Encode bug in MakeMakeFiles for some modules
  def cpanm(*args)
    result = `cpanm #{args.join ' '}`
    if $? != 0
      raise Puppet::ExecutionFailure, result
    end
    return result
  end

  def latest?
    begin
      name = @resource[:name]
      if name.include? "@"
        name_parts = name.split('@')
        name = "#{name_parts[0]}"
        version = "#{name_parts[1]}"
      end
      installed = `perl -e 'require Module::Metadata; $meta = Module::Metadata->new_from_module("#{name}"); if ($meta) {print $meta->version} else {exit 1}'`
    rescue Puppet::ExecutionFailure
      installed=''
    end
    options = []
    if @resource[:mirror]
      options << "--from"
      options << @resource[:mirror]
    end
    options << '--info'
    options << @resource[:name]

    cpan=cpanm(options).split("\n")[-1].match(/([0-9]+\.?[0-9]*).tar.gz/)
    if cpan
      latest = cpan[1]
      Puppet.debug("Installed: #{installed}, CPAN: #{latest}")
      if latest > installed
        return false
      end
    end
    return true
  end

  def create
    options = []

    if @resource[:mirror]
      options << "--from"
      options << @resource[:mirror]
    end

    if @resource[:force] == :true || @resource[:force] == true
      options << "-f"
    end

    if @resource[:test] == :false || @resource[:test] == false
      options << "-n"
    end

    options << @resource[:name]

    cpanm(options)
  end

  #  alias update create
  def destroy
    begin
      cpanm '-U', '-f', @resource[:name]
    rescue Puppet::ExecutionFailure
      #error = Puppet::Error.new("Failed to remove CPAN package: #{e}")
      #error.set_backtrace(e.backtrace)
      #raise error
    end
  end

  def exists?
    begin
      name = @resource[:name]
      if name.include? "@"
        name_parts = name.split('@')
        name = "#{name_parts[0]}"
        version = "#{name_parts[1]}"
      end
      installed = `perl -e 'require Module::Metadata; $meta = Module::Metadata->new_from_module("#{name}"); if ($meta) {print $meta->version} else {exit 1}'`
      if $? != 0
        raise Puppet::ExecutionFailure, installed
      end
      if version.is_number?
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
  end

  def self.instances
    modules = {}
    name = nil
    perldoc('-tT', 'perllocal').split("\n").each do |r|
      if r.include?('"Module"') then
        name = r.split[-1]
        modules[name] = new(:name => name)
      end
      if r.include?('VERSION: ') and name
        r.split[-1].delete('"')
        #modules[name].version = version
      end
    end
    modules.map do |k,v| v end
  end
end
