require "mpesa_stk/access_token"

module MpesaStk
  class PushPayment
    class << self
      def call(amount, phone_number, ref_token = "")
        new(amount, phone_number, ref_token).push_payment
      end
    end

    attr_reader :token, :amount, :phone_number, :ref_token

    def initialize(amount, phone_number, ref_token)
      @token = MpesaStk::AccessToken.call
      @amount = amount
      @phone_number = phone_number
      @ref_token = ref_token
    end

    def push_payment
      response = HTTParty.post(url, headers: headers, body: body)
      JSON.parse(response.body)
    end

    private

    def url
      "#{MpesaStk.configuration.daraja_base_url}/mpesa/stkpush/v1/processrequest"
    end

    def headers
      headers = {
        "Authorization" => "Bearer #{token}",
        "Content-Type" => "application/json",
      }
    end

    def body
      {
        BusinessShortCode: "#{MpesaStk.configuration.business_short_code}",
        Password: generate_password,
        Timestamp: "#{timestamp}",
        TransactionType: "CustomerBuyGoodsOnline",
        Amount: "#{amount}",
        PartyA: "#{phone_number}",
        PartyB: "#{MpesaStk.configuration.party_b}",
        PhoneNumber: "#{phone_number}",
        CallBackURL: "#{MpesaStk.configuration.callback_url}?ref_token=#{ref_token}",
        AccountReference: generate_bill_reference_number(5),
        TransactionDesc: generate_bill_reference_number(5),
      }.to_json
    end

    def generate_bill_reference_number(number)
      charset = Array("A".."Z") + Array("a".."z")
      Array.new(number) { charset.sample }.join
    end

    def timestamp
      DateTime.now.strftime("%Y%m%d%H%M%S").to_i
    end

    # shortcode
    # passkey
    # timestamp
    def generate_password
      key = "#{MpesaStk.configuration.business_short_code}#{MpesaStk.configuration.business_pass_key}#{timestamp}"
      Base64.encode64(key).split("\n").join
    end
  end
end
