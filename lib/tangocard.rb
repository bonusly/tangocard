require 'rubygems'
require 'httparty'
require 'money'
require 'ostruct'

module Tangocard
  class Configuration
    attr_accessor :name, :key, :base_uri, :default_brands, :local_images, :sku_blacklist

    def initialize
      self.name = nil
      self.key = nil
      self.base_uri = "https://sandbox.tangocard.com"
      self.default_brands = [
          'Tango Card',
          'Amazon.com',
          'Apple iTunes',
          'Barnes & Noble',
          'Best Buy',
          'Facebook',
          'Fandango',
          'Gap',
          'Grameen',
          'Habitat for Humanity',
          'Hulu+',
          'Nike',
          'REI',
          'Sephora',
          'Starbucks',
          'Target',
          'Walmart',
          'Zappos'
      ]
      self.local_images = {}
      self.sku_blacklist = ["TNGO-C-V-STD"]
    end
  end

  def self.configuration
    @configuration ||=  Configuration.new
  end

  def self.configure
    yield(configuration) if block_given?
  end
end

Dir["./lib/tangocard/*.rb"].each {|f| require f}