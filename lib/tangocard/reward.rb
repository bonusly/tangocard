# Documentation: https://github.com/tangocarddev/RaaS
class Tangocard::Reward
  attr_reader :description, :sku, :currency_type, :unit_price, :available, :min_price, :max_price

  def initialize(params)
    @description = params['description']
    @sku = params['sku']
    @currency_type = params['currency_type']
    @unit_price = params['unit_price'].to_i
    @available = params['available']
    @min_price = params['min_price'].to_i
    @max_price = params['max_price'].to_i
  end

  def variable_price?
    self.unit_price == -1
  end

  def purchasable?(balance_in_cents)
    return false unless available

    if variable_price?
      min_price <= balance_in_cents
    else
      unit_price <= balance_in_cents
    end
  end

  def price_in_usd(field_name)
    return nil unless [:min_price, :max_price, :unit_price].include?(field_name)

    Money.new(self.send(field_name), currency_type)
  end
end