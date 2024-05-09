# app/services/xero_token_service.rb
require 'net/http'
require 'uri'
require 'base64'

class XeroTokenService
  XERO_TOKEN_URL = 'https://identity.xero.com/connect/token'.freeze

  def initialize(client_id, client_secret, scopes)
    @client_id = client_id
    @client_secret = client_secret
    @scopes = scopes
  end

  def generate_token
    uri = URI(XERO_TOKEN_URL)
    request = Net::HTTP::Post.new(uri)
    request['Authorization'] = "Basic " + base64_encode_credentials
    request['Content-Type'] = 'application/x-www-form-urlencoded'
    request.body = "grant_type=client_credentials&scope=#{@scopes}"
    response = Net::HTTP.start(uri.hostname, uri.port, use_ssl: true) do |http|
      http.request(request)
    end
    response.body
  end

  private

  def base64_encode_credentials
    Base64.strict_encode64("#{@client_id}:#{@client_secret}")
  end
end