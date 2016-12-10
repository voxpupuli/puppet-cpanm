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
        provider.create
      end
      Puppet.notice('wat')
      return :present
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
