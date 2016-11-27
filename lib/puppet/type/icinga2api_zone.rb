Puppet::Type.newtype(:icinga2api_zone) do

  @doc = 'Manage Icinga2 zone objects via API.'

  ensurable

  newparam(:name, :namevar => true) do
    desc 'The name of the Icinga2 zone objects to manage.'
    defaultto Facter.value('fqdn')
  end

  
  newparam(:parent) do
    desc 'The Icinga2 zone which is parent to this zone.'
  end
 
end

