module Foreman
  class Client
    DEFAULTS = {
      :effective_user => 'admin',
      :timeout => 500
    }

    def initialize(settings)
      @settings = DEFAULTS.merge(settings)
    end

    def settings
      @settings
    end

    def oauth_consumer_key
      @oauth_consumer_key ||= begin
        YAML.load_file('/etc/foreman/settings.yaml')[:oauth_consumer_key]
      rescue
        fail "Resource cannot be managed: No OAuth Consumer Key available"
      end
    end

    def oauth_consumer_secret
      @oauth_consumer_secret ||= begin
        YAML.load_file('/etc/foreman/settings.yaml')[:oauth_consumer_secret]
      rescue
        fail "Resource cannot be managed: No OAuth consumer secret available"
      end
    end

    def oauth_consumer
      @consumer ||= OAuth::Consumer.new(oauth_consumer_key, oauth_consumer_secret, {
        :site               => settings[:base_url],
        :request_token_path => '',
        :authorize_path     => '',
        :access_token_path  => '',
        :timeout            => settings[:timeout],
        :ca_file            => settings[:ssl_ca]
      })
    end

    def generate_token
      OAuth::AccessToken.new(oauth_consumer)
    end

    def request(method, path, params = {}, data = nil, headers = {})
      base_url = settings[:base_url]
      base_url += '/' unless base_url.end_with?('/')

      uri = URI.join(base_url, URI.encode(path))
      uri.query = params.map { |p,v| "#{URI.escape(p.to_s)}=#{URI.escape(v.to_s)}" }.join('&') unless params.empty?

      headers = {
        'Accept' => 'application/json',
        'Content-Type' => 'application/json',
        'foreman_user' => settings[:effective_user]
      }.merge(headers)

      attempts = 0
      begin
        if [:post, :put, :patch].include?(method)
          response = oauth_consumer.request(method, uri.to_s, generate_token, {}, data, headers)
        else
          response = oauth_consumer.request(method, uri.to_s, generate_token, {}, headers)
        end
        response
      rescue Timeout::Error => te
        attempts = attempts + 1
        if attempts < 5
          retry
        else
          raise Puppet::Error.new("Timeout calling API at #{uri}", te)
        end
      rescue Exception => ex
        raise Puppet::Error.new("Exception #{ex} in #{method} request to: #{uri}", ex)
      end
    end

    def success?(response)
      (200..299).include?(response.code.to_i)
    end

    def error_message(response)
      JSON.parse(response.body)['error']['full_messages'].join(' ') rescue "unknown error (response #{response.code})"
    end
  end
end
