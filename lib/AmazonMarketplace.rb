$:.unshift(File.dirname(__FILE__)) unless
  $:.include?(File.dirname(__FILE__)) || $:.include?(File.expand_path(File.dirname(__FILE__)))

require 'active_support'
require 'AmazonMarketplace/Yml'

module AmazonMarketplace
  
  VERSION = '0.1.0' unless const_defined?(:VERSION)

  mattr_accessor :aws_access_key_id
  mattr_accessor :aws_secret_access_key
  mattr_accessor :account_id  

  mattr_accessor :use_sandbox
  @@use_sandbox = true
  
  Yml.load

  def self.use_sandbox?
    @@use_sandbox
  end

end

require 'AmazonMarketplace/service'
require 'AmazonMarketplace/helpers/form_helper'

