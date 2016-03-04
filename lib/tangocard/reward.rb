class Tangocard::Reward
  attr_reader :type, :description, :sku, :is_variable, :denomination, :min_price, :max_price,
              :currency_code, :available, :countries

  def initialize(params)
    @type          = params['type']
    @description   = params['description']
    @sku           = params['sku']
    @is_variable   = params['is_variable']
    @denomination  = params['denomination'].to_i
    @min_price     = params['min_price'].to_i
    @max_price     = params['max_price'].to_i
    @currency_code = params['currency_code']
    @available     = params['available']
    @countries     = params['countries']
  end

  # Is this a variable-priced reward?
  #
  # Example:
  #   >> reward.variable_price?
  #    => true # reward is variable-priced
  #
  # Arguments:
  #   none
  def variable_price?
    is_variable
  end

  # Is this reward purchasable given a certain number of cents available to purchase it?
  # True if reward is available and user has enough cents
  # False if reward is unavailable OR user doesn't have enough cents
  #
  # Example:
  #   >> reward.purchasable?(500)
  #    => true # reward is available and costs <= 500 cents
  #
  # Arguments:
  #   balance_in_cents: (Integer)
  def purchasable?(balance_in_cents)
    return false unless available

    if variable_price?
      min_price <= balance_in_cents
    else
      denomination <= balance_in_cents
    end
  end

  # Converts price in cents for given field to Money object using currency_code
  #
  # Example:
  #   >> reward.to_money(:unit_price)
  #    => #<Money fractional:5000 currency:USD>
  #
  # Arguments:
  #   field_name: (Symbol - must be :min_price, :max_price, or :denomination)
  def to_money(field_name)
    return nil unless [:min_price, :max_price, :denomination].include?(field_name)

    Money.new(self.send(field_name), currency_code)
  end
end
