require 'json'

require File.expand_path(File.join(File.dirname(__FILE__), '..', 'icinga2api_tasks.rb'))

Puppet::Type.type(:icinga2api_zone).provide(:ruby, :parent => Puppet::Provider::Icinga2ApiTasks) do
  mk_resource_methods

  def self.instances
    instances = []
    icinga2api_instances('zones').each do |zone|
      instances << new(
        :ensure                => :present,
        :name                  => zone['attrs']['__name'],
        :parent                => zone['attrs']['parent'],
        :endpoints             => zone['attrs']['endpoints'],
        :global                => zone['attrs']['global'],
      )
    end
   instances
  end

  def self.prefetch(resources)
    zones = instances
    resources.keys.each do |name|
      if provider = zones.find{ |zone| zone.name == name }
        resources[name].provider = provider
      end
    end
  end

  def map_resource_data(resource)
    object_data = {}
    object_data[:attrs] = {}
    [ 'parent', 'endpoints', 'global' ].each do |attribute|
      object_data[:attrs][attribute] = resource[attribute]
    end
    object_data
  end

  def create
    icinga2api_create('zones', @resource['name'], map_resource_data(@resource))
  end

  def flush
    icinga2api_update('zones', @resource['name'], map_resource_data(@resource))
  end

  def exists?
    @property_hash[:ensure] == :present
  end


end
