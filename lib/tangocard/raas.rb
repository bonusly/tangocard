# Documentation: https://github.com/tangocarddev/RaaS
class Tangocard::Raas
  include HTTParty

  # https://github.com/tangocarddev/RaaS/blob/master/account_create.schema.json
  def self.create_account(params)
    base_uri Tangocard.configuration.base_uri
    Tangocard::Response.new(post('/raas/v1/accounts', {:body => params.to_json}.merge(basic_auth_param)))
  end

  def self.show_account(params)
    base_uri Tangocard.configuration.base_uri
    Tangocard::Response.new(get("/raas/v1/accounts/#{params['customer']}/#{params['identifier']}", basic_auth_param))
  end

  # https://github.com/tangocarddev/RaaS/blob/master/fund_create.schema.json
  def self.fund_account(params)
    base_uri Tangocard.configuration.base_uri
    Tangocard::Response.new(post('/raas/v1/funds', {:body => params.to_json}.merge(basic_auth_param)))
  end

  def self.rewards_index
    base_uri Tangocard.configuration.base_uri
    Tangocard::Response.new(get('/raas/v1/rewards', basic_auth_param))
  end

  # https://github.com/tangocarddev/RaaS/blob/master/order_create.schema.json
  def self.create_order(params)
    base_uri Tangocard.configuration.base_uri
    Tangocard::Response.new(post('/raas/v1/orders', {:body => params.to_json}.merge(basic_auth_param)))
  end

  def self.show_order(params)
    base_uri Tangocard.configuration.base_uri
    Tangocard::Response.new(get("/raas/v1/orders/#{params['order_id']}", basic_auth_param))
  end

  def self.orders_index(params = {})
    base_uri Tangocard.configuration.base_uri
    query_string = ""
    if params.any?
      query_string = "?"
      params.keys.each_with_index do |k,i|
        query_string += "&" unless i == 0
        query_string += "#{k}=#{params[k]}"
      end
    end
    Tangocard::Response.new(get("/raas/v1/orders#{query_string}", basic_auth_param))
  end

  private

  def self.basic_auth_param
    {:basic_auth => {:username => Tangocard.configuration.name, :password => Tangocard.configuration.key}}
  end
end