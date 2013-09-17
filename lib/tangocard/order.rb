# Wrapper for Tangocard RaaS Order
# https://github.com/tangocarddev/RaaS#order-resources
class Tangocard::Order
  attr_reader :order_id,
              :account_identifier,
              :customer,
              :sku,
              :amount,
              :reward_message,
              :reward_from,
              :delivered_at,
              :recipient

  private_class_method :new

  #{
  #    "success"=>true,
  #    "order"=> {
  #        "order_id"=>"113-08258652-15",
  #        "account_identifier"=>"ElliottTest",
  #        "customer"=>"ElliottTest",
  #        "sku"=>"APPL-E-1500-STD",
  #        "amount"=>1500,
  #        "reward_message"=>"testing",
  #        "reward_subject"=>"RaaS Sandbox Test",
  #        "reward_from"=>"Elliott",
  #        "delivered_at"=>"2013-08-15T17:42:18+00:00",
  #        "recipient"=> {
  #            "name"=>"Elliott",
  #            "email"=>"elliott@tangocard.com"
  #        },
  #        "reward"=> {
  #            "token"=>"520d12fa655b54.34581245",
  #            "number"=>"1111111111111256"
  #        }
  #    }
  #}

  def self.all(params = {})
    response = Tangocard::Raas.orders_index(params)
    if response.success?
      response.parsed_response['orders'].map{|o| new(o)}
    else
      []
    end
  end

  def self.find(order_id)
    response = Tangocard::Raas.show_order({'order_id' => order_id})
    if response.success?
      new(response.parsed_response['order'])
    else
      raise Tangocard::OrderNotFoundException, "Order (#{order_id}) not found. Error message: #{response.error_message}"
    end
  end

  def self.create(params)
    response = Tangocard::Raas.create_order(params)
    if response.success?
      new(response.parsed_response['order'])
    else
      raise Tangocard::OrderCreateFailedException, "#{response.error_message}"
    end
  end

  def initialize(params)
    @order_id = params['order_id']
    @account_identifier = params['account_identifier']
    @customer = params['customer']
    @sku = params['sku']
    @amount = params['amount']
    @reward_message = params['reward_message']
    @reward_subject = params['reward_subject']
    @reward_from = params['reward_from']
    @delivered_at = params['delivered_at']
    @recipient = params['recipient']
    @reward = params['reward']
  end

  def reward
    if @reward.nil?
      begin
        @reward = Tangocard::Order.find(self.order_id).reward
      rescue Tangocard::OrderNotFoundException => e
        nil
      end
    else
      @reward
    end
  end

  def identifier
    @account_identifier
  end
end