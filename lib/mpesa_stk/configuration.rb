module MpesaStk
  class Configuration
    attr_accessor :daraja_base_url,
                  :consumer_key,
                  :consumer_secret,
                  :business_short_code,
                  :business_pass_key,
                  :callback_url,
                  :party_b

    def initialize
      # Values are set because default values are not provided and must be set by the user

      @daraja_base_url = nil
      @consumer_key = nil
      @consumer_secret = nil
      @business_short_code = nil
      @business_pass_key = nil
      @callback_url = nil
      @party_b = nil
    end
  end
end
