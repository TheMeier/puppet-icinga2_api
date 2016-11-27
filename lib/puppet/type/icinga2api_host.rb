Puppet::Type.newtype(:icinga2api_host) do

  @doc = 'Manage Icinga2 host objects via API.'

  ensurable

  newparam(:name, :namevar => true) do
    desc 'The name of the Icinga2 host objects to manage.'
    defaultto Facter.value('fqdn')
  end

  # KNOWN BUG: you can send template updates to the api but they are
  # simply ignored :(
  newproperty(:templates, :array_matching => :all) do
    desc 'Host template array for this Icinga2 host.'
    def insync?(is)
      is.sort == should.sort
    end
  end
   
  newproperty(:zone) do
    desc 'The Icinga2 zone the Icinga2 host objects is in.'
    defaultto Facter.value('fqdn')
  end
 
  newproperty(:address) do
    desc 'IPv4 address of the host object.'
    defaultto Facter.value(:networking)['ip']
  end 

  newproperty(:address6) do
    desc 'IPv6 address of the host object.'
    defaultto Facter.value(:networking)['ip6']
  end 

  newproperty(:vars) do
  end

end

