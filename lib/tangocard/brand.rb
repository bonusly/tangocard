class Tangocard::Brand
  attr_reader :description, :rewards

  # Return an array of all brands.
  #
  # Example:
  #   >> Tangocard::Brand.all
  #    => [#<Tangocard::Brand:0x007f9a6f9d3030 ...>, #<Tangocard::Brand:0x007f9a6f9d3030 ...>, ...]
  #
  # Arguments:
  #   none
  def self.all
    rewards_index = Tangocard::Raas.rewards_index
    raise Tangocard::RaasException.new("Tangocard error with response code #{rewards_index.code}") unless rewards_index.success?
    rewards_index.parsed_response['brands'].map{|p| Tangocard::Brand.new(p)}
  end

  # Find a brand by its :description field.
  #
  # Example:
  #   >> Tangocard::Brand.find("Amazon.com")
  #    => #<Tangocard::Brand:0x007f96a9cbe980 @description="Amazon.com",
  #       @image_url="https://dwwvg90koz96l.cloudfront.net/graphics/item-images/amazon-gift-card.png",
  #       @rewards=[#<Tangocard::Reward:0x007f96a9cbe930 @type="reward",
  #       @description="Amazon.com Gift Card (Custom)", @sku="AMZN-E-V-STD", @is_variable=true,
  #       @denomination=0, @min_price=1, @max_price=100000, @currency_code="USD", @available=true,
  #       @countries=["US"]>]>
  #
  # Arguments:
  #   brand_name: (String)
  def self.find(brand_name)
    self.all.select{|b| b.description == brand_name}.first
  end

  # Return an array of default brands. You can set :default_brands in your Tangocard initializer
  # to define your desired list of brands. See the README for details.
  #
  # Example:
  #   >> Tangocard::Brand.default
  #    => [#<Tangocard::Brand:0x007f9a6f9d3030 ...>, #<Tangocard::Brand:0x007f9a6f9d3030 ...>, ...]
  #
  # Arguments:
  #   none
  def self.default
    self.all.select{|b| Tangocard.configuration.default_brands.include?(b.description)}
  end

  def initialize(params)
    @description = params['description']
    @image_url = params['image_url']
    @rewards = params['rewards'].map{|p| Tangocard::Reward.new(p)}
  end

  # Return the image_url for the brand.  For some brands, there is no image_url. You can set :local_images in your
  # Tangocard initializer to provide a local image for a specified brand.  See the README for details.
  #
  # Example:
  #   >> amazon_brand.image_url
  #    => "http://static-integration.tangocard.com/graphics/item-images/amazon-gift-card.png"
  #
  # Arguments:
  #   none
  def image_url
    Tangocard.configuration.local_images[description] || @image_url
  end

  # Return the rewards that are purchasable given a balance (in cents).
  #
  # Example:
  #   >> itunes_brand.purchasable_rewards(1000)
  #    => [#<Tangocard::Reward:0x007f96aa3b4dc0 @type="reward", @description="iTunes Code USD $5",
  #        @sku="APPL-E-500-STD", @is_variable=false, @denomination=500, @min_price=0, @max_price=0,
  #        @currency_code="USD", @available=true, @countries=["US"]>,
  #        #<Tangocard::Reward:0x007f96aa3b4d98 @type="reward", @description="iTunes Code USD $10",
  #        @sku="APPL-E-1000-STD", @is_variable=false, @denomination=1000, @min_price=0, @max_price=0,
  #        @currency_code="USD", @available=true, @countries=["US"]>]
  #
  # Arguments:
  #   balance_in_cents: (Integer)
  def purchasable_rewards(balance_in_cents)
    rewards.select{|r| r.purchasable?(balance_in_cents) && !Tangocard.configuration.sku_blacklist.include?(r.sku)}
  end

  # True if there are any purchasable rewards given a balance in cents, false otherwise.
  #
  # Example:
  #   >> itunes_brand.has_purchasable_rewards?(1000)
  #    => true
  #
  # Arguments:
  #   balance_in_cents: (Integer)
  def has_purchasable_rewards?(balance_in_cents)
    purchasable_rewards(balance_in_cents).any?
  end

  # True if this is a brand with variable-price rewards.
  #
  # Example:
  #   >> itunes_brand.variable_price?
  #    => false
  #   >> amazon_brand.variable_price?
  #    => true
  #
  # Arguments:
  #   none
  def variable_price?
    rewards.select{|r| r.variable_price? }.any?
  end
end
