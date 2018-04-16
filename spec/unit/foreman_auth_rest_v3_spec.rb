require 'spec_helper'

provider_class = Puppet::Type.type(:foreman_auth).provider(:rest_v3)
describe provider_class do
  let(:resource) do
    Puppet::Type.type(:foreman_auth).new(
      :name => 'LDAP Auth',

      :base_url => 'https://foreman.example.com',
      :consumer_key => 'oauth_key',
      :consumer_secret => 'oauth_secret',
      :effective_user => 'admin',

      :account => 'bind-account.svc',
      :account_password => 'testing',
      :attr_firstname => 'gn',
      :attr_lastname => 'sn',
      :attr_login => 'uid',
      :attr_mail => 'email',
      :attr_photo => '',
      :base_dn => 'DC=example,DC=com',
      :host => 'ldaps.foreman.example.com',
      :groups_base => 'DC=example,DC=com',
      :onthefly_register => true,
      :usergroup_sync => true,
      :port => 636,
      :server_type => 'Active Directory',
      :tls => true
    )
  end

  let(:provider) do
    provider = provider_class.new
    provider.resource = resource
    provider
  end

  let(:client) do
    client = Foreman::Client.new(
      :base_url => resource[:base_url],
      :ssl_ca => resource[:ssl_ca],
    )
    client
  end

  describe '#create' do
    it 'sends POST request' do
      client.expects(:request).with(:post, 'api/v2/auth_source_ldaps', {}, is_a(String)).once.returns(
        OpenStruct.new(:code => '200')
      )
      provider.expects(:client).at_least_once.returns(client)

      provider.create
    end
  end

  describe '#destroy' do
    it 'sends DELETE request' do
      provider.expects(:id).returns(1)
      client.expects(:request).with(:delete, 'api/v2/auth_source_ldaps/1').once.returns(
        OpenStruct.new(:code => '200')
      )
      provider.expects(:client).at_least_once.returns(client)

      provider.destroy
    end
  end

  describe '#exists?' do
    it 'returns true when ID is present' do
      provider.expects(:id).returns(1)
      expect(provider.exists?).to be true
    end

    it 'returns nil when ID is absent' do
      provider.expects(:id).returns(nil)
      expect(provider.exists?).to be false
    end
  end
end
