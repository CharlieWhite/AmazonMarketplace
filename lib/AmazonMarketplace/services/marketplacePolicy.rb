module AmazonMarketplace
  module Services
  
    ##
    # The Amazon Simple Pay Marketplace Policy service is used to allow sellers to acknowledge marketplace policy fees.
    # Only once a set policy has been agreed to will marketplace transactions be able to proceed.
    #
    # === Simple Pay Marketplace Policy Fields
    # 
    # ==== Required Fields
    # 
    # The following attributes are required when creating a Simple Pay Marketplace policy fee acceptance form
    # (in addition to those listed in +AmazonMarketplace::Service+):
    # 
    # max_fixed_fee:: The maximum fixed fee that will be appended to transactions.
    # max_variable_fee:: The maximum variable fee (%) that will be calculated and added to transactions.
    # reference_id:: A custom string used to identify this transaction, it will be returned with return data.
    #
    # === Example
    # 
    #     (in your view, using the form helper)
    #
    #     <%= AmazonMarketplace_form_for(:marketplacePolicy, {
    #       :max_fixed_fee => 10.00,
    #       :max_variable_fee => 5,
    #       :reference_id => '123456789'
    #     }) %>
    #
    class MarketplacePolicy < Service
      require 'AmazonMarketplace/signature_utils'
      
      class << self
      # Loaded from YML config
        attr_accessor 'return_url'
      end
      
       # Function creates a Map of key-value pairs for all valid values passed to the function 
       

      def self.get_params(attributes)
        form_hidden_inputs = {}
        if (Service.access_key== nil) then
            raise ArgumentError, 'AccessKey is required parameter'
        else
            form_hidden_inputs["callerKey"] = Service.access_key.to_s
        end
        if (Service.signature_method == nil) then
            raise ArgumentError, 'Signature Method is required parameter' 
        else
            form_hidden_inputs[@@SIGNATURE_METHOD_KEYNAME] = Service.signature_method.to_s 
        end 
        if (self.return_url == nil) then
            raise ArgumentError, 'Return_url is required parameter' 
        else
    	      form_hidden_inputs["returnUrl"] = self.return_url.to_s
        end

        form_hidden_inputs["pipelineName"] = "Recipient"
        form_hidden_inputs["recipientPaysFee"] = "True"
        form_hidden_inputs["collectEmailAddress"] = "True"
        
        form_hidden_inputs["callerReference"] = attributes[:caller_reference].to_s
       
        form_hidden_inputs["maxFixedFee"] = attributes[:fixed_marketplace_fee].to_s unless attributes[:fixed_marketplace_fee].nil?
        form_hidden_inputs["maxvariableFee"] = attributes[:variable_marketplace_fee].to_s unless attributes[:variable_marketplace_fee].nil?

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


      def self.get_accept_marketplace_fee_button_form(form_hidden_inputs,service_end_point,image_location,path)
        form = "<form target='_top' action=\"https://" + service_end_point + path + "\" method=\"" + @@CBUIhttp_method + "\">\n"
        form += "<input type=\"image\" src=\""+image_location+"\" border=\"0\">\n"
        form_hidden_inputs.each { |k,v|
            form += "<input type=\"hidden\" name=\"" + k + "\" value=\"" + v + "\" >\n"
        }
        form += "</form>\n"
      end

       # Attributes Required:
       # callerReference -Optionally, enter an ID that uniquely identifies this transaction for callers Record
       # fixedMarketplaceFee - Optionally, enter the fixed market place fee
       # variableMarketplaceFee - Optionally, enter the variable market place fee
       

      def self.generate_form(attributes)
        if (Service.environment == "prod") then
    	endPoint = @@PROD_END_POINT;
    	imageLocation = @@PROD_MP_IMAGE_LOCATION;
        else
    	 endPoint = @@SANDBOX_END_POINT;
    	 imageLocation = @@SANDBOX_MP_IMAGE_LOCATION;	
        end 
        uri = URI.parse(endPoint)
        params = get_params(attributes)

        signature = SignatureUtils.sign_parameters({:parameters => params, 
                                                :aws_secret_key => Service.secret_key,
                                                :host => uri.host,
                                                :verb => @@CBUIhttp_method,
                                                :uri  => @@CBUI_REQUEST_URI,
    					    :algorithm => Service.signature_method })
        params[@@SIGNATURE_KEYNAME] = signature
        accept_marketplace_fee_button_form = get_accept_marketplace_fee_button_form(params,uri.host,imageLocation,@@CBUI_REQUEST_URI)
        return accept_marketplace_fee_button_form
      end
    end
    
  end
end
