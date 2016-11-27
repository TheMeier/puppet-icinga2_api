require 'json'

require File.expand_path(File.join(File.dirname(__FILE__), '..', 'icinga2api_tasks.rb'))

Puppet::Type.type(:icinga2api_host).provide(:ruby, :parent => Puppet::Provider::Icinga2ApiTasks) do

  def self.instances
    instances = []
    icinga2api_instances('hosts').each do |host|
      instances << new(
        :ensure     => :present,
        :name       => host['attrs']['__name'],
        :templates  => host['attrs']['templates'].uniq.delete_if {|n| n == host['attrs']['__name']},
        :address    => host['attrs']['address'],
        :address6   => host['attrs']['address6'],
        :zone       => host['attrs']['zone'],
        :vars       => host['attrs']['vars'],
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

  def create
    object_data = {}
    object_data[:attrs] = {}
    object_data[:templates] = @resource[:templates]
    object_data[:attrs][:address] = @resource['address']
    object_data[:attrs][:address6] = @resource['address6']
    object_data[:attrs][:zone] = @resource['zone']
    object_data[:attrs][:vars] = @resource['vars']
    icinga2api_create('hosts', @resource['name'], object_data)
  end

  def flush
    object_data = {}
    object_data[:attrs] = {}
    object_data[:templates] = @resource[:templates]
    object_data[:attrs][:address] = @resource['address']
    object_data[:attrs][:address6] = @resource['address6']
    object_data[:attrs][:zone] = @resource['zone']
    object_data[:attrs][:vars] = @resource['vars']
    icinga2api_update('hosts', @resource['name'], object_data)
  end

  def exists?
    @property_hash[:ensure] == :present
  end

  mk_resource_methods

end


