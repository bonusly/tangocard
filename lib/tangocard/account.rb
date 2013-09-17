# Wrapper for Tangocard RaaS Account
# https://github.com/tangocarddev/RaaS#account-resources
class Tangocard::Account
  attr_reader :customer, :identifier, :email, :available_balance

  private_class_method :new

  # parsed_response={"success"=>true, "account"=>{"identifier"=>"test1", "email"=>"test@test.com", "customer"=>"bonusly", "available_balance"=>0}}
  def self.find(customer, identifier)
    response = Tangocard::Raas.show_account({'customer' => customer, 'identifier' => identifier})
    if response.success?
      new(response.parsed_response['account'])
    else
      raise Tangocard::AccountNotFoundException, "Tangocard - Error finding account: #{response.error_message}"
    end
  end

  def self.create(customer, identifier, email)
    response = Tangocard::Raas.create_account({'customer' => customer, 'identifier' => identifier, 'email' => email})
    if response.success?
      new(response.parsed_response['account'])
    else
      raise Tangocard::AccountCreateFailedException, "Tangocard - Error finding account: #{response.error_message}"
    end
  end

  def self.find_or_create(customer, identifier, email)
    begin
      find(customer, identifier)
    rescue Tangocard::AccountNotFoundException => e
      create(customer, identifier, email)
    end
  end

  # {"identifier"=>"test1", "email"=>"test@test.com", "customer"=>"bonusly", "available_balance"=>0}
  def initialize(params)
    @customer = params['customer']
    @email = params['email']
    @identifier = params['identifier']
    @available_balance = params['available_balance'].to_i
  end

  def balance
    @available_balance
  end

  def fund!(amount, client_ip, credit_card)
    params = {
        'amount' => amount,
        'client_ip' => client_ip,
        'credit_card' => credit_card,
        'customer' => customer,
        'account_identifier' => identifier
    }
    Tangocard::Raas.fund_account(params)
  end
end