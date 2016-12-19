Puppet::Type.type(:cpanm).provide(:default) do
  desc 'Manage CPAN modules with cpanm'

  commands :cpanm => 'cpanm'
  commands :perl => 'perl'

  def latest?
    installed=`perl -m#{@resource[:name]} -e 'print $#{@resource[:name]}::VERSION' 2>/dev/null`
    cpan=`cpanm --info #{@resource[:name]} | tail -1`.match(/([0-9]+\.?[0-9]*).tar.gz/)
    if cpan
      latest = cpan[1]
      Puppet.debug("Installed: #{installed}, CPAN: #{latest}")
      if latest > installed
        Puppet.debug('Ruby thinks CPAN is newer, so upgrades will happen now')
        return false
      end
    end
    return true
  end

  def create
    Puppet.info "create cpanm #{@resource[:name]}"

    options = ""

    if @resource[:force] == :true
      options << " -f"
    end

    if @resource[:test] == :false
      options << " -n"
    end

    command = "cpanm #{options} #{@resource[:name]}"
    Puppet.debug(command)
    if !system(command)
      raise Puppet::Error, "install of CPAN module #{@resource[:name]} failed"
    end
  end

#  alias update create
  def destroy
    Puppet.info "destroy cpanm #{@resource[:name]}"
    command = "cpanm -U -f #{@resource[:name]}"
    Puppet.debug(command)
    system(command)
  end

  def exists?
    command = "perl -M#{@resource[:name]} -e1 >/dev/null 2>&1"
    Puppet.debug(command)
    if system(command)
      return true
    end
    return false
  end
end
