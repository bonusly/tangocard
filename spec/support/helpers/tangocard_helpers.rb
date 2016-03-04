module TangocardHelpers
  def sample_parsed_response
    @sample_parsed_response ||= JSON.parse(File.read(File.dirname(__FILE__) + '/../fixtures/sample_response.json'))
  end

  def sample_brand_variable
    sample_parsed_response['brands'].select{|b| b['description'] == 'Amazon.com'}.first
  end

  def sample_brand_fixed
    sample_parsed_response['brands'].select{|b| b['description'] == 'Hulu+'}.first
  end

  # return either a successful or failed find account response
  def sample_find_account_response(success)
    if success
      raw_response = OpenStruct.new(
          parsed_response: {
              "success"=>true,
              "account"=> {
                  "identifier"=>"test1",
                  "email"=>"test@test.com",
                  "customer"=>"bonusly",
                  "available_balance"=>5000
              }
          },
          code: 200
      )
    else
      raw_response = OpenStruct.new(
          parsed_response: {
              "success"=>false,
              "error_message"=>"user not found for platform"
          },
          code: 403
      )
    end
    Tangocard::Response.new(raw_response)
  end

  # return either a successful or failed create account response
  def sample_create_account_response(success)
    if success
      raw_response = OpenStruct.new(
          parsed_response: {
              "success"=>true,
              "account"=> {
                  "identifier"=>"asdfasdfasdf",
                  "email"=>"asdfasdf@asdfasdf.com",
                  "customer"=>"bonusly",
                  "available_balance"=>0
              }
          },
          code: 200
      )
    else
      raw_response = OpenStruct.new(
          parsed_response: {
              "success"=>false,
              "error_message"=>"The account already exists for the platform."
          },
          code: 403
      )
    end
    Tangocard::Response.new(raw_response)
  end

  # return either a successful or failed fund account response
  def sample_fund_account_response(success)
    if success
      raw_response = OpenStruct.new(
        parsed_response: {"success"=>true, "fund_id"=>"RF13-09261098-12", "amount"=>5000},
        code: 200
      )
    else
      raw_response = OpenStruct.new(
          parsed_response: {
              "success"=>false,
              "error_message"=>"The supplied input entity was invalid.",
              "invalid_inputs"=>[
                  {
                      "field"=>"credit_card.billing_address.zip",
                      "error"=>"integer value found, but a string is required "
                  }
              ]
          },
          code: 403
      )
    end
    Tangocard::Response.new(raw_response)
  end

  def sample_register_credit_card_response(success)
    if success
      raw_response = OpenStruct.new(
        parsed_response: {"success"=>true, "cc_token"=>"33041234", "active_date"=>1439286111},
        code: 200
      )
    else
      raw_response = OpenStruct.new(
          parsed_response: {
            "success" => false,
            "denial_code" => "CC_DUPEREGISTER",
            "denial_message" => "This payment method has already been registered, it can not be added again. If there are any questions, please call our operations team directly at 1-877-558-2646 (Monday - Friday, 8am - 6pm PDT)."
          },
          code: 400
      )
    end
    Tangocard::Response.new(raw_response)
  end

  def sample_delete_credit_card_response(success)
    if success
      raw_response = OpenStruct.new(
        parsed_response: {"success"=>true, "message"=>"This card is no longer present in the system."},
        code: 200
      )
    else
      raw_response = OpenStruct.new(
          parsed_response: {
            "success" => false,
            "error_message"=>"RAAS:CCUNREG:1000"
          },
          code: 500
      )
    end
    Tangocard::Response.new(raw_response)
  end

  def sample_find_order_response(success)
    if success
      raw_response = OpenStruct.new(
          parsed_response: {
              "success"=>true,
              "order"=> {
                  "order_id"=>"113-08258652-15",
                  "account_identifier"=>"ElliottTest",
                  "customer"=>"ElliottTest",
                  "sku"=>"APPL-E-1500-STD",
                  "denomination"=> {
                      "value"=>1500,
                      "currency_code"=>"USD"
                  },
                  "amount_charged"=> {
                      "value"=>1500,
                      "currency_code"=>"USD"
                  },
                  "reward_message"=>"testing",
                  "reward_subject"=>"RaaS Sandbox Test",
                  "reward_from"=>"Elliott",
                  "delivered_at"=>"2013-08-15T17:42:18+00:00",
                  "recipient"=> {
                      "name"=>"Elliott",
                      "email"=>"elliott@tangocard.com"
                  },
                  "external_id"=>nil,
                  "reward"=> {
                      "token"=>"520d12fa655b54.34581245",
                      "number"=>"1111111111111256"
                  }
              }
          },
          code: 200
      )
    else
      raw_response = OpenStruct.new(
          parsed_response: {
              "success"=>false,
              "error_message"=>"Generic error message."
          },
          code: 403
      )
    end
    Tangocard::Response.new(raw_response)
  end

  def sample_order_index_response(success)
    if success
      raw_response = OpenStruct.new(
          parsed_response: {
              "success"=>true,
              "orders"=> [{
                  "order_id"=>"113-08258652-15",
                  "account_identifier"=>"ElliottTest",
                  "customer"=>"ElliottTest",
                  "sku"=>"APPL-E-1500-STD",
                  "amount"=>1500,
                  "reward_message"=>"testing",
                  "reward_subject"=>"RaaS Sandbox Test",
                  "reward_from"=>"Elliott",
                  "delivered_at"=>"2013-08-15T17:42:18+00:00",
                  "recipient"=> {
                      "name"=>"Elliott",
                      "email"=>"elliott@tangocard.com"
                  }
              }]
          },
          code: 200
      )
    else
      raw_response = OpenStruct.new(
          parsed_response: {
              "success"=>false,
              "error_message"=>"Generic error message."
          },
          code: 403
      )
    end
    Tangocard::Response.new(raw_response)
  end

  def order_create_params(variable)
    params = {
        "customer" => "bonusly-development",
        "account_identifier" => "primary",
        "recipient" => {
            "name" => "Raphael",
            "email" => "raphael@bonus.ly"
        },
        "reward_subject" => "Your bonus.ly reward",
        "reward_message" => "Here is your bonus.ly reward",
        "reward_from" => "bonus.ly",
        "send_reward" => true,
        "external_id" => "bonusly_id"
    }
    if variable
      params.merge({
           "sku" => "AMZN-E-V-STD",
           "amount" => 2500, # if variable only
      })
    else
      params.merge({"sku" => "APPL-E-2500-STD"})
    end
  end

  def sample_create_order_response(success)
    if success
      raw_response = OpenStruct.new(
          parsed_response: {
              "success"=>true,
              "order"=> {
                  "order_id"=>"113-09261158-14",
                  "account_identifier"=>"primary",
                  "customer"=>"bonusly-development",
                  "sku"=>"APUK-E-1500-STD",
                  "denomination"=> {
                      "value"=>1500,
                      "currency_code"=>"GBP"
                  },
                  "amount_charged"=> {
                      "value"=>2327,
                      "currency_code"=>"USD"
                  },
                  "reward_message"=>"Here is your bonus.ly reward",
                  "reward_subject"=>"Your bonus.ly reward",
                  "reward_from"=>"bonus.ly",
                  "delivered_at"=>"2013-09-14T17:09:41+00:00",
                  "recipient"=> {
                      "name"=>"Raphael",
                      "email"=>"raphael@bonus.ly"
                  },
                  "external_id"=>"bonusly_id",
                  "reward"=> {
                      "token"=>"52349855591df1.48777244",
                      "number"=>"AVTBJRHKELLG8MO1"
                  }
              }
          },
          code: 200
      )
    else
      raw_response = OpenStruct.new(
          parsed_response: {
              "success"=>false,
              "error_message"=>"There was insufficient available funds.",
              "available_balance"=>0
          },
          code: 400
      )
    end
    Tangocard::Response.new(raw_response)
  end
end
