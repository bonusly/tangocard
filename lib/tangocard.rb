require 'httparty'
require 'money'
require 'ostruct'

module Tangocard
  class Configuration
    attr_accessor :name, :key, :base_uri, :default_brands, :local_images, :sku_blacklist, :use_cache

    def initialize
      self.name = nil
      self.key = nil
      self.base_uri = 'https://sandbox.tangocard.com'
      self.local_images = {}
      self.sku_blacklist = []
      self.use_cache = true
    end
  end

  def self.configuration
    @configuration ||=  Configuration.new
  end

  def self.configure
    yield(configuration) if block_given?
  end
end

require 'tangocard/response'
require 'tangocard/raas'
require 'tangocard/account'
require 'tangocard/account_create_failed_exception'
require 'tangocard/account_not_found_exception'
require 'tangocard/brand'
require 'tangocard/order'
require 'tangocard/order_create_failed_exception'
require 'tangocard/order_not_found_exception'
require 'tangocard/reward'