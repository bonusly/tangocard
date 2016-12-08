class Tangocard::Raas
  include HTTParty

  # Create a new account. Returns Tangocard::Response object.
  #
  # Example:
  #   >> Tangocard::Raas.create_account(params)
  #    => #<Tangocard::Response:0x007f9a6c4bca68 ...>
  #
  # Arguments:
  #   params: (Hash - see https://www.tangocard.com/docs/raas-api/#create-account for details)
  def self.create_account(params)
    Tangocard::Response.new(post_request('/accounts', { body: params.to_json }))
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
    Tangocard::Response.new(get_request("/accounts/#{params['customer']}/#{params['identifier']}"))
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
    Tangocard::Response.new(post_request('/cc_fund', { body: params.to_json }))
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
    Tangocard::Response.new(post_request('/cc_register', { body: params.to_json }))
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
    Tangocard::Response.new(post_request('/cc_unregister', { body: params.to_json }))
  end

  # Retrieve all rewards. Returns Tangocard::Response object.
  #
  # Example:
  #   >> Tangocard::Raas.rewards_index
  #    => #<Tangocard::Response:0x007f9a6c4bca68 ...>
  #
  # Arguments:
  #   none
  def self.rewards_index(use_cache: true)
    if Tangocard.configuration.use_cache && use_cache
      cached_response = Tangocard.configuration.cache.read("#{Tangocard::CACHE_PREFIX}rewards_index")
      raise Tangocard::RaasException.new('Tangocard cache is not primed. Either configure the gem to run without caching or warm the cache before calling cached endpoints') if cached_response.nil?
      cached_response
    else
      Tangocard::Response.new(get_request('/rewards'))
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
    Tangocard::Response.new(post_request('/orders', { body: params.to_json }))
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
    Tangocard::Response.new(get_request("/orders/#{params['order_id']}"))
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
      params.keys.each_with_index do |k, i|
        query_string += "&" unless i == 0
        query_string += "#{k}=#{params[k]}"
      end
    end
    Tangocard::Response.new(get_request("/orders#{query_string}"))
  end

  private

  def self.basic_auth_param
    { basic_auth: { username: Tangocard.configuration.name, password: Tangocard.configuration.key } }
  end

  def self.endpoint
    "#{Tangocard.configuration.base_uri}/raas/v1.1"
  end

  def self.get_request(path)
    get("#{endpoint}#{path}", basic_auth_param)
  end

  def self.post_request(path, params)
    post("#{endpoint}#{path}", basic_auth_param.merge(params))
  end
end
