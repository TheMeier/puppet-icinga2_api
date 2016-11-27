require 'json'
require 'yaml'
require 'rest-client'
require 'puppet'

module Icinga2Api
  class Rest

    def self.request(options)
      Puppet.debug("Icinga2Api::Rest.request path: #{options[:path]}")
      Puppet.debug("Icinga2Api::Rest.request method: #{options[:method]}")
      Puppet.debug("Icinga2Api::Rest.request data #{options[:object_data].to_s}")
      begin
        RestClient::Request.execute(
          :method     => options[:method],
          :url        => "#{options[:icinga2api_url]}/#{options[:path]}",
          :user       => options[:user],
          :password   => options[:password],
          :verify_ssl => false,  # FIXME # TODO
          :headers    => { :accept => :json, :content_type => :json },
          :payload    => JSON.generate(options[:object_data]),
        )
      rescue => e
        Puppet.warning("Icinga2Api::Rest.request #{options[:method]} failed: #{e.to_s}")
        Puppet.debug("#{__method__} PUT response: #{JSON.parse(e.response)['results'].to_s}")
      end
    end

  
    def self.create(options)
      options[:path] = '/objects/' + options[:type] + '/' + options[:name]
      options[:method] = 'put'
      request(options)
    end

    def self.update(options)
      options[:path] = '/objects/' + options[:type] + '/' + options[:name]
      options[:method] = 'post'
      request(options)
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

