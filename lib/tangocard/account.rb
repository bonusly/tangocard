class Tangocard::Account
  attr_reader :customer, :identifier, :email, :available_balance

  private_class_method :new

  # Find account given customer and identifier. Raises Tangocard::AccountNotFoundException on failure.
  #
  # Example:
  #   >> Tangocard::Account.find('bonusly', 'test')
  #    => #<Tangocard::Account:0x007f9a6fec0138 @customer="bonusly", @email="dev@bonus.ly", @identifier="test", @available_balance=1200>
  #
  # Arguments:
  #   customer: (String)
  #   identifier: (String)
  def self.find(customer, identifier)
    response = Tangocard::Raas.show_account({'customer' => customer, 'identifier' => identifier})
    if response.success?
      new(response.parsed_response['account'])
    else
      raise Tangocard::AccountNotFoundException, "#{response.error_message}"
    end
  end

  # Create account given customer, identifier, and email.
  # Raises Tangocard::AccountCreateFailedException on failure.
  #
  # Example:
  #   >> Tangocard::Account.create('bonusly', 'test', 'dev@bonus.ly')
  #    => #<Tangocard::Account:0x007f9a6fec0138 @customer="bonusly", @email="dev@bonus.ly", @identifier="test", @available_balance=0>
  #
  # Arguments:
  #   customer: (String)
  #   identifier: (String)
  #   email: (String)
  def self.create(customer, identifier, email)
    response = Tangocard::Raas.create_account({'customer' => customer, 'identifier' => identifier, 'email' => email})
    if response.success?
      new(response.parsed_response['account'])
    else
      raise Tangocard::AccountCreateFailedException, "#{response.error_message}"
    end
  end

  # Find account, or create if account not found.
  # Raises Tangocard::AccountCreateFailedException on failure.
  #
  # Example:
  #   >> Tangocard::Account.find_or_create('bonusly', 'test', 'dev@bonus.ly')
  #    => #<Tangocard::Account:0x007f9a6fec0138 @customer="bonusly", @email="dev@bonus.ly", @identifier="test", @available_balance=0>
  #
  # Arguments:
  #   customer: (String)
  #   identifier: (String)
  #   email: (String)
  def self.find_or_create(customer, identifier, email)
    begin
      find(customer, identifier)
    rescue Tangocard::AccountNotFoundException => e
      create(customer, identifier, email)
    end
  end

  def initialize(params)
    @customer = params['customer']
    @email = params['email']
    @identifier = params['identifier']
    @available_balance = params['available_balance'].to_i
  end

  def balance
    @available_balance
  end

  # Add funds to the account.
  #
  # Example:
  #   >> account.fund(10000, '128.128.128.128', Hash (see example below))
  #    => #<Tangocard::Account:0x007f9a6fec0138 @customer="bonusly", @email="dev@bonus.ly", @identifier="test", @available_balance=0>
  #
  # Arguments:
  #   amount: (Integer)
  #   client_ip: (String)
  #   credit_card: (Hash) - see https://github.com/tangocarddev/RaaS/blob/master/fund_create.schema.json for details
  #
  # Credit Card Hash Example:
  # {
  #     'number' => '4111111111111111',
  #     'expiration' => '01/17',
  #     'security_code' => '123',
  #     'billing_address' => {
  #         'f_name' => 'Jane',
  #         'l_name' => 'User',
  #         'address' => '123 Main Street',
  #         'city' => 'Anytown',
  #         'state' => 'NY',
  #         'zip' => '11222',
  #         'country' => 'USA',
  #         'email' => 'jane@company.com'
  #     }
  # }
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