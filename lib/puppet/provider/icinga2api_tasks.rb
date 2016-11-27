require File.expand_path(File.join(File.dirname(__FILE__), '..', '..', 'puppet_x', 'icinga2api', 'rest.rb'))


class Puppet::Provider::Icinga2ApiTasks < Puppet::Provider
  initvars
  confine :feature => :restclient
  @@options = Hash.new()
  @@options[:icinga2api_url] = 'https://localhost.localdomain:5665/v1'
  if File.readable?("/etc/icinga2/pki/ca.crt") and
    @@options[:ssl_ca_file] = "/etc/icinga2/pki/ca.crt"
    if File.readable?("/etc/icinga2/pki/#{Facter.value('fqdn')}.crt") and
      File.readable?("/etc/icinga2/pki/#{Facter.value('fqdn')}.key")
      @@options[:ssl_client_cert] = "/etc/icinga2/pki/#{Facter.value('fqdn')}.crt"
      @@options[:ssl_client_key] = "/etc/icinga2/pki/#{Facter.value('fqdn')}.key"
    end 
  else
    @@options[:user] = 'root'
    @@options[:password] = 'root'
  end
  
  def icinga2api_create(type, name, object_data)
    @@options[:type] = type 
    @@options[:name] = name
    @@options[:type] = type 
    @@options[:object_data] = object_data
    Icinga2Api::Rest.create(@@options)
  end

  def icinga2api_update(type, name, object_data)
    @@options[:type] = type 
    @@options[:name] = name
    @@options[:type] = type 
    @@options[:object_data] = object_data
    Icinga2Api::Rest.update(@@options)
  end

  def self.icinga2api_instances(type)
    @@options[:type] = type
    Icinga2Api::Rest.instances(@@options)
  end
end
