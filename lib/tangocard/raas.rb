class Tangocard::Raas
  include HTTParty

  @@rewards_response_expires_at = 0

  # Create a new account. Returns Tangocard::Response object.
  #
  # Example:
  #   >> Tangocard::Raas.create_account(params)
  #    => #<Tangocard::Response:0x007f9a6c4bca68 ...>
  #
  # Arguments:
  #   params: (Hash - see https://www.tangocard.com/docs/raas-api/#create-account for details)
  def self.create_account(params)
    Tangocard::Response.new(post(endpoint + '/accounts', {:body => params.to_json}.merge(basic_auth_param)))
  end

  # Gets account details. Returns Tangocard::Response object.
  #
  # Example:
  #   >> Tangocard::Raas.show_account(params)
  #    => #<Tangocard::Response:0x007f9a6c4bca68 ...>
  #
  # Arguments:
  #   params: (Hash - see https://www.tangocard.com/docs/raas-api/#get-account for details)
  def self.show_account(params)
    Tangocard::Response.new(get(endpoint + "/accounts/#{params['customer']}/#{params['identifier']}", basic_auth_param))
  end

  # Funds an account. Returns Tangocard::Response object.
  #
  # Example:
  #   >> Tangocard::Raas.cc_fund_account(params)
  #    => #<Tangocard::Response:0x007f9a6c4bca68 ...>
  #
  # Arguments:
  #   params: (Hash - see https://www.tangocard.com/docs/raas-api/#create-cc-fund for details)
  def self.cc_fund_account(params)
    Tangocard::Response.new(post(endpoint + '/cc_fund', {:body => params.to_json}.merge(basic_auth_param)))
  end

  # Registers a credit card to an account. Returns Tangocard::Response object.
  #
  # Example:
  #   >> Tangocard::Raas.register_credit_card(params)
  #    => #<Tangocard::Response:0x007f9a6c4bca68 ...>
  #
  # Arguments:
  #   params: (Hash - see https://www.tangocard.com/docs/raas-api/#create-cc-registration for details)
  def self.register_credit_card(params)
    Tangocard::Response.new(post(endpoint + '/cc_register', {:body => params.to_json}.merge(basic_auth_param)))
  end

  # Deletes a credit card from an account. Returns Tangocard::Response object.
  #
  # Example:
  #   >> Tangocard::Raas.delete_credit_card(params)
  #    => #<Tangocard::Response:0x007f9a6c4bca68 ...>
  #
  # Arguments:
  #   params: (Hash - see https://www.tangocard.com/docs/raas-api/#create-cc-un-registration for details)
  def self.delete_credit_card(params)
    Tangocard::Response.new(post(endpoint + '/cc_unregister', {:body => params.to_json}.merge(basic_auth_param)))
  end

  # Retrieve all rewards. Returns Tangocard::Response object.
  #
  # Example:
  #   >> Tangocard::Raas.rewards_index
  #    => #<Tangocard::Response:0x007f9a6c4bca68 ...>
  #
  # Arguments:
  #   none
  def self.rewards_index
    if Tangocard.configuration.use_cache
      clear_cache! if cache_expired?

      @@rewards_response ||= Tangocard::Response.new(get(endpoint + '/rewards', basic_auth_param))
      @@rewards_response_expires_at = (Time.now.to_i + Tangocard.configuration.cache_ttl) if cache_expired?
      @@rewards_response
    else
      Tangocard::Response.new(get(endpoint + '/rewards', basic_auth_param))
    end
  end

  # Create an order. Returns Tangocard::Response object.
  #
  # Example:
  #   >> Tangocard::Raas.create_order(params)
  #    => #<Tangocard::Response:0x007f9a6c4bca68 ...>
  #
  # Arguments:
  #   params: (Hash - see https://www.tangocard.com/docs/raas-api/#create-order for details)
  def self.create_order(params)
    Tangocard::Response.new(post(endpoint + '/orders', {:body => params.to_json}.merge(basic_auth_param)))
  end

  # Get order details. Returns Tangocard::Response object.
  #
  # Example:
  #   >> Tangocard::Raas.show_order(params)
  #    => #<Tangocard::Response:0x007f9a6c4bca68 ...>
  #
  # Arguments:
  #   params: (Hash - see https://www.tangocard.com/docs/raas-api/#get-order for details)
  def self.show_order(params)
    Tangocard::Response.new(get(endpoint + "/orders/#{params['order_id']}", basic_auth_param))
  end

  # Retrieve a list of historical orders. Returns Tangocard::Response object.
  #
  # Example:
  #   >> Tangocard::Raas.orders_index
  #    => #<Tangocard::Response:0x007f9a6c4bca68 ...>
  #
  # Arguments:
  #   params: (Hash - see https://www.tangocard.com/docs/raas-api/#list-orders for details)
  def self.orders_index(params = {})
    query_string = ""
    if params.any?
      query_string = "?"
      params.keys.each_with_index do |k,i|
        query_string += "&" unless i == 0
        query_string += "#{k}=#{params[k]}"
      end
    end
    Tangocard::Response.new(get(endpoint + "/orders#{query_string}", basic_auth_param))
  end

  def self.clear_cache!
    @@rewards_response = nil
    @@rewards_response_expires_at = 0
  end

  private

  def self.basic_auth_param
    {:basic_auth => {:username => Tangocard.configuration.name, :password => Tangocard.configuration.key}}
  end

  def self.use_cache_ttl?
    Tangocard.configuration.use_cache && Tangocard.configuration.cache_ttl > 0
  end

  def self.cache_expired?
    use_cache_ttl? && @@rewards_response_expires_at < Time.now.to_i
  end

  def self.endpoint
    Tangocard.configuration.base_uri + '/raas/v1.1'
  end
end
