class Yml
  
  require 'yaml'
  require 'AmazonMarketplace/service'
  
  @@yml_file = "#{RAILS_ROOT}/config/amazon_marketplace.yml"
  @@yml = YAML::load(File.read(@@yml_file))
  
  def self.load
      AmazonMarketplace::Service.environment = @@yml['environment']
      AmazonMarketplace::Service.access_key =  @@yml['accessKey']
      AmazonMarketplace::Service.secret_key =   @@yml['secretKey']
      AmazonMarketplace::Service.signature_method =   @@yml['signatureMethod']
      AmazonMarketplace::Services::MarketplacePolicy.return_url =   @@yml['marketplace_policy']['returnUrl']
      AmazonMarketplace::Services::Marketplace.abandon_url =   @@yml['marketplace']['abandonUrl']
      AmazonMarketplace::Services::Marketplace.return_url =    @@yml['marketplace']['returnUrl']
      AmazonMarketplace::Services::Marketplace.immediate_return =   @@yml['marketplace']['immediateReturn']
      AmazonMarketplace::Services::Marketplace.process_immediate =   @@yml['marketplace']['processImmediate']
      AmazonMarketplace::Services::Marketplace.ipn_url =   @@yml['marketplace']['ipnUrl']
      AmazonMarketplace::Services::Marketplace.collect_shipping_address =   @@yml['marketplace']['collectShippingAddress']
   end
 end