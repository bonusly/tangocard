class Tangocard::Raas
  include HTTParty

  # Create a new account. Returns Tangocard::Response object.
  #
  # Example:
  #   >> Tangocard::Raas.create_account(params)
  #    => #<Tangocard::Response:0x007f9a6c4bca68 ...>
  #
  # Arguments:
  #   params: (Hash - see https://github.com/tangocarddev/RaaS#create-a-new-platform-account for details)
  def self.create_account(params)
    Tangocard::Response.new(post(endpoint + 'accounts', {:body => params.to_json}.merge(basic_auth_param)))
  end

  # Gets account details. Returns Tangocard::Response object.
  #
  # Example:
  #   >> Tangocard::Raas.show_account(params)
  #    => #<Tangocard::Response:0x007f9a6c4bca68 ...>
  #
  # Arguments:
  #   params: (Hash - see https://github.com/tangocarddev/RaaS#get-the-information-for-a-specific-platform-account for details)
  def self.show_account(params)
    Tangocard::Response.new(get(endpoint + "/accounts/#{params['customer']}/#{params['identifier']}", basic_auth_param))
  end

  # Funds an account. Returns Tangocard::Response object.
  #
  # Example:
  #   >> Tangocard::Raas.fund_account(params)
  #    => #<Tangocard::Response:0x007f9a6c4bca68 ...>
  #
  # Arguments:
  #   params: (Hash - see https://github.com/tangocarddev/RaaS#fund-a-platforms-account for details)
  def self.fund_account(params)
    Tangocard::Response.new(post(endpoint + '/funds', {:body => params.to_json}.merge(basic_auth_param)))
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
    Tangocard::Response.new(get(endpoint + '/rewards', basic_auth_param))
  end

  # Create an order. Returns Tangocard::Response object.
  #
  # Example:
  #   >> Tangocard::Raas.create_order(params)
  #    => #<Tangocard::Response:0x007f9a6c4bca68 ...>
  #
  # Arguments:
  #   params: (Hash - see https://github.com/tangocarddev/RaaS#place-an-order for details)
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
  #   params: (Hash - see https://github.com/tangocarddev/RaaS#retrieve-a-historical-order for details)
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
  #   params: (Hash - see https://github.com/tangocarddev/RaaS#retrieve-a-list-of-historical-orders for details)
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

  private

  def self.basic_auth_param
    {:basic_auth => {:username => Tangocard.configuration.name, :password => Tangocard.configuration.key}}
  end

  def self.endpoint
    Tangocard.configuration.base_uri + '/raas/v1'
  end
end