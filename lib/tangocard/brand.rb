# Documentation: https://github.com/tangocarddev/RaaS
class Tangocard::Brand
  attr_reader :description, :rewards

  def self.all
    result = Rails.cache.fetch("tangocard-brands") do
      Tangocard::Raas.rewards_index.parsed_response
    end
    result['brands'].map{|p| Tangocard::Brand.new(p)}
  end

  def self.default_brands
    self.all.select{|b| TANGOCARD::DEFAULT_BRANDS.include?(b.description)}
  end

  def self.find(brand_name)
    self.all.select{|b| b.description == brand_name}.first
  end

  def initialize(params)
    @description = params['description']
    @image_url = params['image_url']
    @rewards = params['rewards'].map{|p| Tangocard::Reward.new(p)}
  end

  # Some brands don't have logo images provided by the API, so we do this.
  def image_url
    TANGOCARD::LOCAL_IMAGES[description] || @image_url
  end

  def purchasable_rewards(balance_in_cents)
    rewards.select{|r| r.purchasable?(balance_in_cents) && !TANGOCARD::SKU_BLACKLIST.include?(r.sku)}
  end

  def has_purchasable_rewards?(balance_in_cents)
    purchasable_rewards(balance_in_cents).any?
  end

  def variable_price?
    rewards.select{|r| r.variable_price? }.any?
  end
end