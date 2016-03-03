class Tangocard::Order
  attr_reader :order_id,
              :account_identifier,
              :customer,
              :sku,
              :denomination,
              :amount_charged,
              :reward_message,
              :reward_subject,
              :reward_from,
              :delivered_at,
              :recipient,
              :external_id,
              :reward,
              :raw_response

  private_class_method :new

  # Return an array of all orders.
  #
  # Example:
  #   >> Tangocard::Order.all
  #    => [#<Tangocard::Order:0x007f9a6c4bca68 ...>, #<Tangocard::Order:0x007f9a6c4bca68 ...>, ...]
  #
  # Arguments:
  #   params: (Hash - optional, see https://www.tangocard.com/docs/raas-api/#list-orders for details)
  def self.all(params = {})
    response = Tangocard::Raas.orders_index(params)
    if response.success?
      response.parsed_response['orders'].map{|o| new(o)}
    else
      []
    end
  end

  # Find an order by order_id. Raises Tangocard::OrderNotFoundException on failure.
  #
  # Example:
  #   >> Tangocard::Order.find("113-08258652-15")
  #    => #<Tangocard::Order:0x007f9a6e3a90c0 @order_id="113-08258652-15", @account_identifier="ElliottTest", @customer="ElliottTest", @sku="APPL-E-1500-STD", @amount=1500, @reward_message="testing", @reward_subject="RaaS Sandbox Test", @reward_from="Elliott", @delivered_at="2013-08-15T17:42:18+00:00", @recipient={"name"=>"Elliott", "email"=>"elliott@tangocard.com"}, @reward={"token"=>"520d12fa655b54.34581245", "number"=>"1111111111111256"}>
  #
  # Arguments:
  #   order_id: (String)
  def self.find(order_id)
    response = Tangocard::Raas.show_order({'order_id' => order_id})
    if response.success?
      new(response.parsed_response['order'], response)
    else
      raise Tangocard::OrderNotFoundException, "#{response.error_message}"
    end
  end

  # Create a new order. Raises Tangocard::OrderCreateFailedException on failure.
  #
  # Example:
  #   >> Tangocard::Order.create(params)
  #    => #<Tangocard::Order:0x007f9a6c4bca68 ...>
  #
  # Arguments:
  #   params: (Hash - see https://www.tangocard.com/docs/raas-api/#create-order for details)
  def self.create(params)
    response = Tangocard::Raas.create_order(params)
    if response.success?
      new(response.parsed_response['order'], response)
    else
      raise Tangocard::OrderCreateFailedException, "#{response.error_message} #{response.invalid_inputs}"
    end
  end

  def initialize(params, raw_response = nil)
    @order_id           = params['order_id']
    @account_identifier = params['account_identifier']
    @customer           = params['customer']
    @sku                = params['sku']
    @denomination       = params['denomination'] || {}
    @amount_charged     = params['amount_charged'] || {}
    @reward_message     = params['reward_message']
    @reward_subject     = params['reward_subject']
    @reward_from        = params['reward_from']
    @delivered_at       = params['delivered_at']
    @recipient          = params['recipient'] || {}
    @external_id        = params['external_id']
    @reward             = params['reward'] || {}
    @raw_response       = raw_response
  end

  def reward
    @reward ||= {}
  end

  def identifier
    @account_identifier
  end
end
