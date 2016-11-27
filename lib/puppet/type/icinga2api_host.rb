# rubocop:disable Metrics/BlockLength
Puppet::Type.newtype(:icinga2api_host) do
  @doc = 'Manage Icinga2 host objects via API.'

  ensurable

  newparam(:name, namevar: true) do
    desc 'The name of the Icinga2 host objects to manage.'
    defaultto Facter.value('fqdn')
  end

  # KNOWN BUG: you can send template updates to the api but they are
  # simply ignored :(
  newproperty(:templates, array_matching: :all) do
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

  newproperty(:vars)
  newproperty(:action_url)
  newproperty(:check_command)
  newproperty(:check_interval)
  newproperty(:check_period)
  newproperty(:check_timeout)
  newproperty(:command_endpoint)
  newproperty(:enable_active_checks)
  newproperty(:enable_event_handler)
  newproperty(:enable_flapping)
  newproperty(:enable_notifications)
  newproperty(:enable_passive_checks)
  newproperty(:enable_perfdata)
  newproperty(:event_command)
  newproperty(:flapping_threshold)
  newproperty(:groups)
  newproperty(:icon_image)
  newproperty(:icon_image_alt)
  newproperty(:max_check_attempts)
  newproperty(:notes)
  newproperty(:notes_url)
  newproperty(:retry_interval)
  newproperty(:volatile)
end
