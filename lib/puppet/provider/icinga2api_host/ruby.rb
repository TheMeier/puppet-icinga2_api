require 'json'

require File.expand_path(File.join(File.dirname(__FILE__), '..', 'icinga2api_tasks.rb'))

Puppet::Type.type(:icinga2api_host).provide(:ruby, :parent => Puppet::Provider::Icinga2ApiTasks) do

  def self.instances
    instances = []
    icinga2api_instances('hosts').each do |host|
      instances << new(
        :ensure                => :present,
        :name                  => host['attrs']['__name'],
# templates array meight contain duplicates and the host create api automatically generates
# and applies a template with the hostname
        :templates             => host['attrs']['templates'].uniq.delete_if {|n| n == host['attrs']['__name']},
        :address               => host['attrs']['address'],
        :address6              => host['attrs']['address6'],
        :groups                => host['attrs']['groups'],
        :vars                  => host['attrs']['vars'],
        :check_command         => host['attrs']['check_command'],
        :max_check_attempts    => host['attrs']['max_check_attempts'],
        :check_period          => host['attrs']['check_period'],
        :check_timeout         => host['attrs']['check_timeout'],
        :check_interval        => host['attrs']['check_interval'],
        :retry_interval        => host['attrs']['retry_interval'],
        :enable_notifications  => host['attrs']['enable_notifications'],
        :enable_active_checks  => host['attrs']['enable_active_checks'],
        :enable_passive_checks => host['attrs']['enable_passive_checks'],
        :enable_event_handler  => host['attrs']['enable_event_handler'],
        :enable_flapping       => host['attrs']['enable_flapping'],
        :enable_perfdata       => host['attrs']['enable_perfdata'],
        :event_command         => host['attrs']['event_command'],
        :flapping_threshold    => host['attrs']['flapping_threshold'],
        :volatile              => host['attrs']['volatile'],
        :zone                  => host['attrs']['zone'],
        :command_endpoint      => host['attrs']['command_endpoint'],
        :notes                 => host['attrs']['notes'],
        :notes_url             => host['attrs']['notes_url'],
        :action_url            => host['attrs']['action_url'],
        :icon_image            => host['attrs']['icon_image'],
        :icon_image_alt        => host['attrs']['icon_image_alt'],
      )
    end
   instances
  end

  def self.prefetch(resources)
    hosts = instances
    resources.keys.each do |name|
      if provider = hosts.find{ |host| host.name == name }
        resources[name].provider = provider
      end
    end
  end

  def map_resource_data(resource)
    object_data = {}
    object_data[:templates] = @resource[:templates]
    object_data[:attrs] = {}
    [ 'action_url', 'address', 'address6', 'check_command', 'check_interval', 'check_period',
      'check_timeout', 'command_endpoint', 'enable_active_checks', 'enable_event_handler',
      'enable_flapping', 'enable_notifications', 'enable_passive_checks', 'enable_perfdata',
      'event_command', 'flapping_threshold', 'groups', 'icon_image', 'icon_image_alt',
      'max_check_attempts', 'notes', 'notes_url', 'retry_interval', 'volatile', 'vars', 'zone' ].each do |attribute|
      unless resource[attribute].nil? ; object_data[:attrs][attribute] = resource[attribute] end
    end
    object_data
  end

  def create
    icinga2api_create('hosts', @resource['name'], map_resource_data(@resource))
  end

  def flush
    icinga2api_update('hosts', @resource['name'], map_resource_data(@resource))
  end

  def exists?
    @property_hash[:ensure] == :present
  end

  mk_resource_methods

end


