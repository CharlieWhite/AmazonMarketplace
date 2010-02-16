#require 'AmazonMarketplace/authentication'

module AmazonMarketplace
  module Helpers
    
    ##
    # Adds a +valid_AmazonMarketplace_request?+ method to your ActionControllers.
    # 
    # In order to use this, you should just directly hand your +params+ into
    # the method:
    # 
    #     class FooController < ApplicationController
    #     
    #       def receive_ipn
    #         if valid_AmazonMarketplace_request?(params)
    #           ... record something useful ...
    #         else
    #           ... maybe log a bad request? ...
    #         end
    #       end
    #     
    #     end
    # 
    module NotificationHelper
      
      protected
      
      
      ##
      # Authenticates the incoming request by validating the +signature+ 
      # provided.
      # 
      #     (from within your controller)
      #     def receive_ipn
      #       if valid_AmazonMarketplace_request?(params)
      #         ...
      #       end
      #     end
      # 
     def valid_AmazonMarketplace_request?(request_hash)
        hash      = request_hash.symbolize_keys
        signature = hash.delete(:signature) || ''
        AmazonMarketplace::SignatureUtils.authentic?(hash, signature)
      end
      
    end
    
  end
end
