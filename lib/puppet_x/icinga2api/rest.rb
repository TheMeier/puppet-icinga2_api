require 'json'
require 'yaml'
require 'rest-client'
require 'puppet'

module Icinga2Api
  class Rest
  
    def self.create(options)
      path = '/objects/' + options[:type] + '/' + options[:name]

      client = RestClient::Resource.new(
        options[:icinga2api_url],
        :user       => options[:user],
        :password   => options[:password],
        :verify_ssl => false  # FIXME # TODO
      )
      Puppet.debug("Icinga2Api::Rest.create path: #{path}")
      Puppet.debug("Icinga2Api::Rest.create PUT data #{options[:object_data].to_s}")
      begin
        client[path].put JSON.generate(options[:object_data]),  :accept => :json, :content_type => :json 
      rescue => e
        Puppet.warning("Icinga2Api::Rest.create PUT failed: #{e.to_s}")
        Puppet.debug("Icinga2Api::Rest.create PUT response: #{JSON.parse(e.response)['results'].to_s}")
      end
    end

    def self.update(options)
      path = '/objects/' + options[:type] + '/' + options[:name]

      client = RestClient::Resource.new(
        options[:icinga2api_url],
        :user       => options[:user],
        :password   => options[:password],
        :verify_ssl => false  # FIXME # TODO
      )
      Puppet.debug("Icinga2Api::Rest.update path: #{path}")
      Puppet.debug("Icinga2Api::Rest.update POST data #{options[:object_data].to_s}")
      begin
        client[path].post JSON.generate(options[:object_data]),  :accept => :json, :content_type => :json 
      rescue => e
        Puppet.warning("Icinga2Api::Rest.create POST failed: #{e.to_s}")
        Puppet.debug("Icinga2Api::Rest.create POST response: #{JSON.parse(e.response)['results'].to_s}")
      end
    end

    def self.instances(options)
      path = '/objects/' + options[:type]
      client = RestClient::Resource.new(
        options[:icinga2api_url],
        :user       => options[:user],
        :password   => options[:password],
        :verify_ssl => false  # FIXME # TODO
      )
      begin
        response = client[path].get :accept => :json, :content_type => :json 
      rescue => e
        Puppet.warning("Rest call failed " + e.to_s)
        Puppet.debug(e.response)
      end
      begin
        JSON.parse(response)['results']
      rescue => e
        Puppet.warning("Could not parse result from API: " + response)
      end
    end


  end 

end        

