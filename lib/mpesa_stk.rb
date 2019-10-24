require "mpesa_stk/version"
require "mpesa_stk/configuration"
require "mpesa_stk/push_payment"
require "httparty"

module MpesaStk
  class << self
    attr_writer :configuration
  end

  def self.configuration
    @configuration ||= Configuration.new
  end

  def self.reset
    @configuration = Configuration.new
  end

  def self.configure
    yield(configuration)
  end
end
