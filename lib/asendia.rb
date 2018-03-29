require 'nokogiri'
require 'httparty'

module Asendia
  class << self
    attr_accessor :configuration
  end

  def self.configuration
    @configuration ||= Configuration.new
  end

  def self.configure
    yield(configuration)
  end

  autoload :Configuration, 'asendia/configuration'
  autoload :Builder, 'asendia/builder'
  autoload :Request, 'asendia/request'
  autoload :Response, 'asendia/response'
  autoload :Shipment, 'asendia/shipment'
  autoload :Service,  'asendia/service'
end
