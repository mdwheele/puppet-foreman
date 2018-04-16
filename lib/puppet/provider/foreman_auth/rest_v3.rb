require File.expand_path(File.join(File.dirname(__FILE__), '..', '..', '..', 'puppet_x', 'foreman', 'client.rb'))

Puppet::Type.type(:foreman_auth).provide(:rest_v3) do
  confine :feature => [:json, :oauth]

  def b2i(value)
    value ? 1 : 0
  end

  def client
    Foreman::Client.new(
      :base_url => resource[:base_url],
      :ssl_ca => resource[:ssl_ca],
    )
  end

  def source
    @source ||= begin
      r = client.request(:get, 'api/v2/auth_source_ldaps', search: %(name="#{resource[:name]}"))
      unless client.success?(r)
        raise Puppet::Error,
          "LDAP #{resource[:name]} cannot be retrieved: #{client.error_message(r)}"
      end
      JSON.parse(r.body)['results'][0]
    end
  end

  def id
    source ? source['id'] : nil
  end

  def create
    server_type = servertype_to_s(resource[:server_type])
    case server_type
    when 'active_directory'
      attr_login = 'userPrincipalName'
    else
      attr_login = 'uid'
    end
    port = resource[:tls] ? '636' : '389'
    post_data = {
      auth_source_ldap: {
        account:           resource[:account],
        account_password:  resource[:account_password],
        attr_firstname:    resource[:attr_firstname] || 'givenname',
        attr_lastname:     resource[:attr_lastname] || 'sn',
        attr_login:        resource[:attr_login] || attr_login,
        attr_mail:         resource[:attr_mail] || 'mail',
        attr_photo:        resource[:attr_photo],
        base_dn:           resource[:base_dn],
        host:              resource[:host],
        name:              resource[:name],
        onthefly_register: b2i(resource[:onthefly_register]) || false,
        port:              resource[:port] || port,
        server_type:       server_type,
        tls:               b2i(resource[:tls]) || true
       }
    }.to_json
    r = client.request(:post, 'api/v2/auth_source_ldaps', {}, post_data)
    unless client.success?(r)
      raise Puppet::Error,
            "LDAP #{resource[:name]} cannot be registered: #{client.error_message(r)}"
    end
  end

  def destroy
    r = client.request(:delete, "api/v2/auth_source_ldaps/#{id}")
    unless client.success?(r)
      raise Puppet::Error,
        "LDAP #{resource[:name]} cannot be removed: #{error_message(r)}"
    end
    @source = nil
  end

  def exists?
    !id.nil?
  end

  def account
    source['account']
  end

  def account=(value)
    put_data = {
      auth_source_ldap: {
        account: value
      }
    }.to_json
    r = client.request(:put, "api/v2/auth_source_ldaps/#{id}", {}, put_data)
    unless client.success?(r)
      raise Puppet::Error,
        "LDAP #{resource[:account]} cannot be updated: #{client.error_message(r)}"
    end
  end

  def account_password
    source['account_password']
  end

  def account_password=(value)
    put_data = {
      auth_source_ldap: {
        account_password: value
      }
    }.to_json
    r = client.request(:put, "api/v2/auth_source_ldaps/#{id}", {}, put_data)
    unless client.success?(r)
      raise Puppet::Error,
        "LDAP #{resource[:account_password]} cannot be updated: #{client.error_message(r)}"
    end
  end

  def attr_firstname
    source['attr_firstname']
  end

  def attr_firstname=(value)
    put_data = {
      auth_source_ldap: {
        attr_firstname: value
      }
    }.to_json
    r = client.request(:put, "api/v2/auth_source_ldaps/#{id}", {}, put_data)
    unless client.success?(r)
      raise Puppet::Error,
        "LDAP #{resource[:attr_firstname]} cannot be updated: #{client.error_message(r)}"
    end
  end

  def attr_lastname
    source['attr_lastname']
  end

  def attr_lastname=(value)
    put_data = {
      auth_source_ldap: {
        attr_lastname: value
      }
    }.to_json
    r = client.request(:put, "api/v2/auth_source_ldaps/#{id}", {}, put_data)
    unless client.success?(r)
      raise Puppet::Error,
        "LDAP #{resource[:attr_lastname]} cannot be updated: #{client.error_message(r)}"
    end
  end

  def attr_login
    source['attr_login']
  end

  def attr_login=(value)
    put_data = {
      auth_source_ldap: {
        attr_login: value
      }
    }.to_json
    r = client.request(:put, "api/v2/auth_source_ldaps/#{id}", {}, put_data)
    unless client.success?(r)
      raise Puppet::Error,
        "LDAP #{resource[:attr_login]} cannot be updated: #{client.error_message(r)}"
    end
  end

  def attr_mail
    source['attr_mail']
  end

  def attr_mail=(value)
    put_data = {
      auth_source_ldap: {
        attr_mail: value
      }
    }.to_json
    r = client.request(:put, "api/v2/auth_source_ldaps/#{id}", {}, put_data)
    unless client.success?(r)
      raise Puppet::Error,
        "LDAP #{resource[:attr_mail]} cannot be updated: #{client.error_message(r)}"
    end
  end

  def attr_photo
    source['attr_photo']
  end

  def attr_photo=(value)
    put_data = {
      auth_source_ldap: {
        attr_photo: value
      }
    }.to_json
    r = client.request(:put, "api/v2/auth_source_ldaps/#{id}", {}, put_data)
    unless client.success?(r)
      raise Puppet::Error,
        "LDAP #{resource[:attr_photo]} cannot be updated: #{client.error_message(r)}"
    end
  end

  def base_dn
    source['base_dn']
  end

  def base_dn=(value)
    put_data = {
      auth_source_ldap: {
        base_dn: value
      }
    }.to_json
    r = client.request(:put, "api/v2/auth_source_ldaps/#{id}", {}, put_data)
    unless client.success?(r)
      raise Puppet::Error,
        "LDAP #{resource[:base_dn]} cannot be updated: #{client.error_message(r)}"
    end
  end

  def groups_base
    source['groups_base']
  end

  def groups_base=(value)
    put_data = {
      auth_source_ldap: {
        groups_base: value
      }
    }.to_json
    r = client.request(:put, "api/v2/auth_source_ldaps/#{id}", {}, put_data)
    unless client.success?(r)
      raise Puppet::Error,
        "LDAP #{resource[:groups_base]} cannot be updated: #{client.error_message(r)}"
    end
  end

  def host
    source['host']
  end

  def host=(value)
    put_data = {
      auth_source_ldap: {
        host: value
      }
    }.to_json
    r = client.request(:put, "api/v2/auth_source_ldaps/#{id}", {}, put_data)
    unless client.success?(r)
      raise Puppet::Error,
        "LDAP #{resource[:host]} cannot be updated: #{client.error_message(r)}"
    end
  end

  def onthefly_register
    source['onthefly_register']
  end

  def onthefly_register=(value)
    put_data = {
      auth_source_ldap: {
        onthefly_register: b2i(value)
      }
    }.to_json
    r = client.request(:put, "api/v2/auth_source_ldaps/#{id}", {}, put_data)
    unless client.success?(r)
      raise Puppet::Error,
        "LDAP #{resource[:onthefly_register]} cannot be updated: #{client.error_message(r)}"
    end
  end

  def port
    source['port']
  end

  def port=(value)
    put_data = {
      auth_source_ldap: {
        port: value
      }
    }.to_json
    r = client.request(:put, "api/v2/auth_source_ldaps/#{id}", {}, put_data)
    unless client.success?(r)
      raise Puppet::Error,
        "LDAP #{resource[:port]} cannot be updated: #{client.error_message(r)}"
    end
  end

  def server_type
    s_to_servertype(source['server_type'])
  end

  def server_type=(value)
    put_data = {
      auth_source_ldap: {
        server_type: servertype_to_s(value)
      }
    }.to_json
    r = client.request(:put, "api/v2/auth_source_ldaps/#{id}", {}, put_data)
    unless client.success?(r)
      raise Puppet::Error,
        "LDAP #{resource[:server_type]} cannot be updated: #{client.error_message(r)}"
    end
  end

  def tls
    source['tls']
  end

  def tls=(value)
    put_data = {
      auth_source_ldap: {
        tls: b2i(value)
      }
    }.to_json
    r = client.request(:put, "api/v2/auth_source_ldaps/#{id}", {}, put_data)
    unless client.success?(r)
      raise Puppet::Error,
        "LDAP #{resource[:tls]} cannot be updated: #{client.error_message(r)}"
    end
  end

  def usergroup_sync
    source['usergroup_sync']
  end

  def usergroup_sync=(value)
    put_data = {
      auth_source_ldap: {
        usergroup_sync: b2i(value)
      }
    }.to_json
    r = client.request(:put, "api/v2/auth_source_ldaps/#{id}", {}, put_data)
    unless client.success?(r)
      raise Puppet::Error,
        "LDAP #{resource[:usergroup_sync]} cannot be updated: #{client.error_message(r)}"
    end
  end

  def servertype_to_s(name)
    case name.to_s
    when 'Active Directory'
      'active_directory'
    when 'FreeIPA'
      'free_ipa'
    when 'POSIX'
      'posix'
    else
      "unknown - #{name}"
    end
  end

  def s_to_servertype(name)
    case name
    when 'posix'
      'POSIX'
    when 'active_directory'
      'Active Directory'
    when 'free_ipa'
      'FreeIPA'
    end
  end

end
