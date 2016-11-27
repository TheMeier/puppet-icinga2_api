require 'json'
require 'yaml'
require 'rest-client'
require 'puppet'

module Icinga2Api
  # wrapper class to handle all rest calls to icinga2 api
  class Rest
    # rubocop:disable Metrics/AbcSize
    def self.request(options)
      Puppet.debug("Icinga2Api::Rest.request path: #{options[:path]}")
      Puppet.debug("Icinga2Api::Rest.request method: #{options[:method]}")
      Puppet.debug("Icinga2Api::Rest.request data #{options[:object_data]}")
      begin
        RestClient::Request.execute(
          method: options[:method],
          url: "#{options[:icinga2api_url]}/#{options[:path]}",
          user: options[:user],
          ssl_ca_file: options[:ssl_ca_file],
          ssl_client_cert: OpenSSL::X509::Certificate.new(File.read(options[:ssl_client_cert])),
          ssl_client_key: OpenSSL::PKey::RSA.new(File.read(options[:ssl_client_key])),
          password: options[:password],
          headers: { accept: :json, content_type: :json },
          payload: JSON.generate(options[:object_data])
        )
      rescue => e
        Puppet.warning("Icinga2Api::Rest.request #{options[:method]} failed: #{e}")
        Puppet.debug("#{__method__} PUT response: #{JSON.parse(e.response)['results']}")
      end
    end
    # rubocop:enable Metrics/AbcSize

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

    # rubocop:disable Metrics/AbcSize
    def self.instances(options)
      path = '/objects/' + options[:type]
      begin
        response = RestClient::Request.execute(
          url: "#{options[:icinga2api_url]}/#{path}",
          method: 'get',
          user: options[:user],
          password: options[:password],
          ssl_ca_file: options[:ssl_ca_file],
          ssl_client_cert: OpenSSL::X509::Certificate.new(File.read(options[:ssl_client_cert])),
          ssl_client_key: OpenSSL::PKey::RSA.new(File.read(options[:ssl_client_key])),
          verify_ssl: OpenSSL::SSL::VERIFY_PEER,
          headers: { accept: :json, content_type: :json }
        )
        JSON.parse(response)['results']
      rescue => e
        Puppet.warning("Icinga2Api::Rest.query #{options[:method]} failed: #{e}")
        Puppet.debug("#{__method__} query response: #{e.inspect}")
      end
    end
    # rubocop:enable Metrics/AbcSize
  end
end
