module AmazonMarketplace
  module Services
  
    ##
    # The Amazon Simple Pay Marketplace service is used to facilitate payments for others.
    # Use it to charge a commission fee for brokering the exchange between buyers and sellers.
    #
    # Note that sellers must accept your marketplace fee policy before the payment buttons
    # for their products can be generated. This can be accomplished using the +MarketplacePolicy+
    # service with the form helper (see examples).
    # 
    # === Simple Pay Marketplace Fields
    # 
    # ==== Required Fields
    # 
    # The following attributes are required when creating a Simple Pay 
    # Marketplace form (in addition to those listed in +AmazonMarketplace::Service+):
    # 
    # amount:: The dollar value you'd like to collect.
    # description:: A summary of the reason for the payment, this is displayed to your customer during checkout.
    # recipient_email:: The e-mail address of the seller (important and must be correct).
    # fixed_marketplace_fee:: The fixed marketplace fee to add to each transaction.
    # variable_marketplace_fee:: The variable percentage fee to add to each transaction.
    # 
    # ==== Optional Fields
    # 
    # abandon_url:: The fully-qualified URL to send your custom if they cancel during payment.
    # cobranding_style:: Defines the type of cobranding to use during the checkout process.
    # collect_shipping_address:: Tells Amazon whether or not to ask for shipping address and contact information.
    # immediate_return:: Immediately returns the customer to your +return_url+ directly after payment.
    # ipn_url:: Fully-qualified URL to which Amazon will POST instant payment notifications.
    # process_immediately:: Instructs Amazon to immediately process the payment.
    # reference_id:: A custom string your can set to identify this transaction, it will be returned with the IPNs and other returned data.
    # return_url:: Fully-qualified URL for where to send your customer following payment.
    # 
    # === Example
    # 
    #     (in your view, sellers need to accept the marketplace fee policy using the form helper)
    #
    #     <%= AmazonMarketplace_form_for(:marketplacePolicy, {
    #       :max_fixed_fee    => 10.00,
    #       :max_variable_fee => 5,
    #       :return_url       => 'http://yourservice.com'
    #     }) %>
    #
    #     (in your view, payment form generated for end users using the form helper)
    #     
    #     <%= AmazonMarketplace_form_for(:standard, {
    #       :amount                   => 34.95,
    #       :description              => "Mutual profit!",
    #       :recipient_email          => 'seller@gmail.com',
    #       :fixed_marketplace_fee    => 10.00,
    #       :variable_marketplace_fee => 5
    #     }) %>
    # 
    class Marketplace < Service
      require 'AmazonMarketplace/signature_utils'
      
      
        
      class << self
      # Loaded from YML config  
        attr_accessor 'amount'
        attr_accessor 'description'
        attr_accessor 'reference_id'
        attr_accessor 'abandon_url'
        attr_accessor 'return_url'
        attr_accessor 'immediate_return'
        attr_accessor 'process_immediate'
        attr_accessor 'ipn_url'
        attr_accessor 'collect_shipping_address'
        attr_accessor 'recipient_email'
        attr_accessor 'fixed_marketplace_fee'
        attr_accessor 'variable_marketplace_fee'
        attr_accessor 'environment'
      end
      
      # Function creates a Map of key-value pairs for all valid values passed to the function 
       # @param accessKey - Put your Access Key here  
       # @param amount - Enter the amount you want to collect for the item
       # @param description - description - Enter a description of the item
       # @param referenceId - Optionally enter an ID that uniquely identifies this transaction for your records
       # @param abandonUrl - Optionally, enter the URL where senders should be redirected if they cancel their transaction
       # @param returnUrl - Optionally enter the URL where buyers should be redirected after they complete the transaction
       # @param immediateReturn - Optionally, enter "1" if you want to skip the final status page in Amazon Payments, 
       # @param processImmediate - Optionally, enter "1" if you want to settle the transaction immediately else "0". Default value is "1"
       # @param ipnUrl - Optionally, type the URL of your host page to which Amazon Payments should send the IPN transaction information.
       # @param collectShippingAddress - Optionally, enter "1" if you want Amazon Payments to return the buyer's shipping address as part of the transaction information.
       # @param signatureMethod - Valid values are  HmacSHA256 and HmacSHA1
       # @param recipientEmail - Enter the e-mail address for the seller.
       # @param fixedMarketplaceFee - Optionally, enter the fixed market place fee
       # @param variableMarketplaceFee - Optionally, enter the variable market place fee

       # @return - A map of key of key-value pair for all non null parameters

      def self.get_params(attributes)
        form_hidden_inputs = {}
         if (Service.access_key== nil) then
            raise ArgumentError, 'AccessKey is required parameter'
        else
        form_hidden_inputs["accessKey"] = Service.access_key
        end
        if (attributes[:amount] == nil) then
            raise ArgumentError, 'Amount is required parameter'
        else                         
        form_hidden_inputs["amount"] = attributes[:amount].to_s
        end 
        if (attributes[:description] == nil) then        
        raise ArgumentError, 'Description is required parameter'
        else
             form_hidden_inputs["description"] = attributes[:description].to_s
        end
        if (Service.signature_method == nil) then
            raise ArgumentError, 'Signature Method is required parameter'
        else
            form_hidden_inputs[@@SIGNATURE_METHOD_KEYNAME] = Service.signature_method.to_s
        end
        if ( attributes[:recipient_email] == nil) then
            raise ArgumentError, 'Recipient Email is required parameter'
        else
        	form_hidden_inputs["recipientEmail"] = attributes[:recipient_email].to_s
        end
        form_hidden_inputs["referenceId"] = attributes[:reference_id].to_s unless attributes[:reference_id].nil?
        form_hidden_inputs["immediateReturn"] = self.immediate_return.to_s unless self.immediate_return.nil?
        form_hidden_inputs["returnUrl"] = self.return_url.to_s unless self.return_url.nil?
        form_hidden_inputs["abandonUrl"] = self.abandon_url.to_s unless self.abandon_url.nil?
        form_hidden_inputs["processImmediate"] = self.process_immediate.to_s unless self.process_immediate.nil?
        form_hidden_inputs["ipnUrl"] = self.ipn_url.to_s unless self.ipn_url.nil?
        form_hidden_inputs["collectShippingAddress"] = self.collect_shipping_address.to_s unless self.collect_shipping_address.nil?

        form_hidden_inputs["fixedMarketplaceFee"] = attributes[:fixed_marketplace_ee].to_s unless attributes[:fixed_marketplace_fee].nil?
        form_hidden_inputs["variableMarketplaceFee"] = attributes[:variable_marketplace_fee].to_s unless attributes[:variable_marketplace_fee].nil?

        form_hidden_inputs["cobrandingStyle"] = @@COBRANDING_STYLE
        form_hidden_inputs[@@SIGNATURE_VERSION_KEYNAME] = @@SIGNATURE_VERSION

        return form_hidden_inputs
      end

      # Creates a form from the provided key-value pairs
      # @param form_hidden_inputs
      #            - A map of key of key-value pair for all non null parameters
      # @param service_end_point
      #            - The Endpoint to be used based on environment selected
      # @param image_location
      #            - The imagelocation based on environment
      # @return - An html form created using the key-value pairs


      def self.get_marketplace_pay_button_form(form_hidden_inputs,service_end_point,image_location)
        form = "<form target='_top' action=\"" + service_end_point + "\" method=\"" + "POST" + "\">\n"
        form += "<input type=\"image\" src=\""+image_location+"\" border=\"0\">\n"
        form_hidden_inputs.each { |k,v|
            form += "<input type=\"hidden\" name=\"" + k + "\" value=\"" + v + "\" >\n"
        }
        form += "</form>\n"
      end
      
      def self.get_marketplace_pay_button_url(form_hidden_inputs,service_end_point,image_location)
       

       url = 'https://authorize.payments-sandbox.amazon.com/cobranded-ui/actions/start?'
       form_hidden_inputs.each { |k,v|
           url += k + "=" + v + '&'
       }
       return url

        # Uncomment this if you want output in a file
        # File.open('out.htm', 'w') { |f| f.write x.body }
        
      end


       # @param accessKey - Put your Access Key here  
       # @param secretKey - Put your Secret Key here
       # @param amount - Enter the amount you want to collect for the item
       # @param description - description - Enter a description of the item
       # @param referenceId - Optionally enter an ID that uniquely identifies this transaction for your records
       # @param abandonUrl - Optionally, enter the URL where senders should be redirected if they cancel their transaction
       # @param returnUrl - Optionally enter the URL where buyers should be redirected after they complete the transaction
       # @param immediateReturn - Optionally, enter "1" if you want to skip the final status page in Amazon Payments, 
       # @param processImmediate - Optionally, enter "1" if you want to settle the transaction immediately else "0". Default value is "1"
       # @param ipnUrl - Optionally, type the URL of your host page to which Amazon Payments should send the IPN transaction information.
       # @param collectShippingAddress - Optionally, enter "1" if you want Amazon Payments to return the buyer's shipping address as part of the transaction information.
       # @param signatureMethod - Valid values are  HmacSHA256 and HmacSHA1
       # @param recipientEmail - Enter the e-mail address for the seller.
       # @param fixedMarketplaceFee - Optionally, enter the fixed market place fee
       # @param variableMarketplaceFee - Optionally, enter the variable market place fee
       # @param environment - Valid values are "sandbox" or "prod"

      def self.generate_form(attributes)
        if (Service.environment == "prod") then
    	    endPoint = @@PROD_END_POINT;
    	    imageLocation = @@PROD_IMAGE_LOCATION;
        else
    	    endPoint = @@SANDBOX_END_POINT;
    	    imageLocation = @@SANDBOX_IMAGE_LOCATION;	
        end  
        uri = URI.parse(endPoint)
        params = get_params(attributes)
        
        
        signature = SignatureUtils.sign_parameters({:parameters => params, 
                                                   :aws_secret_key => Service.secret_key,
                                                   :host => uri.host,
                                                   :verb => "POST",
                                                   :uri  => uri.path,
              					    :algorithm => Service.signature_method  })
        params[@@SIGNATURE_KEYNAME] = signature
        marketplace_pay_button_form = get_marketplace_pay_button_form(params,endPoint,imageLocation)
        return marketplace_pay_button_form
      end
      
      
      def self.generate_url(attributes)
        if (Service.environment == "prod") then
    	    endPoint = @@PROD_END_POINT;
    	    imageLocation = @@PROD_IMAGE_LOCATION;
        else
    	    endPoint = @@SANDBOX_END_POINT;
    	    imageLocation = @@SANDBOX_IMAGE_LOCATION;	
        end  
        uri = URI.parse(endPoint)
        params = get_params(attributes)
        
        
        signature = SignatureUtils.sign_parameters({:parameters => params, 
                                                   :aws_secret_key => Service.secret_key,
                                                   :host => uri.host,
                                                   :verb => "POST",
                                                   :uri  => uri.path,
              					    :algorithm => Service.signature_method  })
        params[@@SIGNATURE_KEYNAME] = signature
        return get_marketplace_pay_button_url(params,endPoint,imageLocation)
        
      end
      
    end
    
  end
end
