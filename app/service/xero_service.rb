# app/services/xero_service.rb
require 'net/http'
require 'uri'
require 'json'

class XeroService
  XERO_BASE_URL = 'https://api.xero.com/api.xro/2.0'.freeze
  INVOICES = '/Invoices'.freeze

  def initialize(invoice)
    @invoice = invoice
    @client_id = "628ED888721D4805928E16C180051110"
    @client_secret = "Kyfu9HMLiAWiikxb-hTt31eyzcvfPmV3QMYk67JLtzgkFmVU"
    @scopes = "accounting.transactions accounting.reports.read accounting.settings accounting.contacts"
  end

  def create_invoice
    # Map the invoice fields from our system to the Xero invoice fields
    # Set the currency to SGD
    # Call the Xero API to create the invoice
    # Handle the Xero API rate limits
    # If the API call is successful, set @invoice.synced_to_xero = true
  end

  def update_invoice
    # Map the updated invoice fields from our system to the Xero invoice fields
    # Call the Xero API to update the invoice
    # Handle the Xero API rate limits
  end

  def void_invoice
    # Call the Xero API to void the invoice
    # Handle the Xero API rate limits
  end

  private

  def xero_client
    @xero_client ||= begin
      token_service = XeroTokenService.new(@client_id, @client_secret, @scopes)
      token = JSON.parse(token_service.generate_token)
      access_token = token['access_token']
      raise 'Failed to get access token' unless access_token

      access_token
    end
  end

  def request_headers
    {
      'Authorization' => "Bearer #{xero_client}",
      'Accept' => 'application/json'
    }
  end
end