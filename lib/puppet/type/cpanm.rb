Puppet::Type.newtype(:cpanm) do
  @doc = "Manage CPAN modules with cpanminus"
  ensurable do
    defaultto :present
    newvalue(:absent) do
      if provider.exists?
        provider.destroy
      end
    end

    newvalue(:present) do
      unless provider.exists?
        provider.create
      end
    end
    aliasvalue(:installed, :present)

    newvalue(:latest) do
      unless provider.latest?
        Puppet.info('not latest, going to create')
        provider.create
        return
      end
      Puppet.notice('falling off the end, this will look like a change')
    end

    def should_to_s(newvalue = @should)
        Puppet.debug("Should is #{newvalue}")
        if provider.latest?
            'latest'
        else
            newvalue.to_s
        end
    end

    def change_to_s(current, new)
        super current, new
    end
  end

  newparam(:name) do
    desc "The CPAN module to manage"
  end

  newparam(:force, :boolean => true) do
    desc "Force installation"
    defaultto :false
  end

  newparam(:test, :boolean => true) do
    desc "Run CPAN module tests"
    defaultto :false
  end
end
