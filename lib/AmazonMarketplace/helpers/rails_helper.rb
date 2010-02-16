require 'action_view/base'

module AmazonMarketplace
  module Helpers
    
    ##
    # Adds helpers to your views for generating the correct HTML forms and 
    # valid signatures.
    # 
    module RailsHelper
      
      ##
      # This is the general interface for generating your Simple Pay service
      # forms.  See AmazonMarketplace::Services for available services and information
      # specific to each.
      # 
      # === Example
      # 
      #     (in your view)
      # 
      #     <%= AmazonMarketplace_form_for(:service_name, {:attr => 'foo'}) %>
      # 
      def AmazonMarketplace_form_for(service_name, attributes = {}, submit_tag = nil)
        service = get_AmazonMarketplace_service(service_name)
        service.generate_form(attributes)
      end
      
      def AmazonMarketplace_url_for(service_name, attributes = {}, submit_tag = nil)
        service = get_AmazonMarketplace_service(service_name)
        service.generate_url(attributes)
      end
      
      
      private
      
      
      def get_AmazonMarketplace_service(name) #:nodoc:
        service = "AmazonMarketplace::Services::#{name.to_s.camelize}".constantize
      end
      
    end
    
  end
end
