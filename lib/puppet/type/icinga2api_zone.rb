Puppet::Type.newtype(:icinga2api_zone) do

  @doc = 'Manage Icinga2 zone objects via API.'

  ensurable

  newparam(:name, :namevar => true) do
    desc 'The name of the Icinga2 zone objects to manage.'
    defaultto Facter.value('fqdn')
  end

  
  newproperty(:parent) do
    desc 'The Icinga2 zone which is parent to this zone.'
  end
 
  newproperty(:endpoints, :array_matching => :all) do
    desc 'Endpoint object to this zone.'
  end
 
  newproperty(:global, :boolean => true) do
    desc 'Endpoint object to this zone.'
    defaultto false
  end
 
end

