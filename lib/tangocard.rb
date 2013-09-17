require 'rubygems'
require 'httparty'
Dir["./lib/tangocard/*.rb"].each {|f| require f}

module Tangocard
  class Configuration
    attr_accessor :name, :key, :base_uri

    def initialize
      self.name = nil
      self.key = nil
      self.base_uri = "https://sandbox.tangocard.com"
    end
  end

  def self.configuration
    @configuration ||=  Configuration.new
  end

  def self.configure
    yield(configuration) if block_given?
  end
end