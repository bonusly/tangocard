class Tangocard::ExchangeRate
  attr_reader :currency_code, :rate

  # Clear all cached responses. Next request for exchange rate info will pull fresh from the Tango Card API.
  #
  # Example:
  #   >> Tangocard::ExchangeRate.clear_cache!
  #    => true
  #
  # Arguments:
  #   none
  def self.clear_cache!
    Tangocard::Raas.clear_cache!
  end

  # Return current currency exchange rate timestamp.
  #
  # Example:
  #   >> Tangocard::ExchangeRate.timestamp
  #    => 1456956187
  #
  # Arguments:
  #   none
  def self.timestamp
    Tangocard::Raas.rewards_index.parsed_response['xrates']['timestamp']
  end

  # Return an array of all currency exchange rates.
  #
  # Example:
  #   >> Tangocard::ExchangeRate.all
  #    => [#<Tangocard::ExchangeRate:0x007ff31ab927a0 @currency_code="USD", @rate="1.00000">,
  #        #<Tangocard::ExchangeRate:0x007ff31ab92750 @currency_code="JPY", @rate="123.44700">, ...]
  #
  # Arguments:
  #   none
  def self.all
    Tangocard::Raas.rewards_index.parsed_response['xrates']['rates'].map do |currency_code, rate|
      Tangocard::ExchangeRate.new(currency_code, rate)
    end
  end

  # Find a exchange rate by its currency code.
  #
  # Example:
  #   >> Tangocard::ExchangeRate.find("EUR")
  #    => #<Tangocard::ExchangeRate:0x007ff31a2dd808 @currency_code="EUR", @rate="0.88870">
  #
  # Arguments:
  #   currency_code: (String)
  def self.find(currency_code)
    self.all.select{|r| r.currency_code == currency_code}.first
  end

  # Set all available exchange rates for Money gem. Once set allows to get reward USD representation
  # of other currencies. For more information and use cases refer to Money gem docs.
  #
  # Example:
  #   >> Tangocard::ExchangeRate.populate_money_rates
  #    => true
  #   >> reward.to_money(:denomination)
  #    => #<Money fractional:500 currency:EUR>
  #   >> reward.to_money(:denomination).exchange_to('USD')
  #    => #<Money fractional:563 currency:USD>
  #
  # Arguments:
  #   none
  def self.populate_money_rates
    self.all.each {|r| Money.add_rate(r.currency_code, 'USD', r.inverse_rate)}
    true
  end

  def initialize(currency_code, rate)
    @currency_code = currency_code
    @rate = rate.to_f
  end

  # Return an inverse rate of original (float). Used to pupulate Money gem rates.
  #
  # Arguments:
  #   none
  def inverse_rate
    1.0 / rate
  end

end
