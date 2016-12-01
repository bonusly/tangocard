require 'spec_helper'

describe Tangocard::Account do
  include TangocardHelpers

  let(:customer) { Object.new }
  let(:identifier) { Object.new }
  let(:email) { Object.new }
  let(:available_balance) { Object.new }
  let(:credit_card) { Object.new }
  let(:client_ip) { Object.new }
  let(:cc_token) { Object.new }
  let(:security_code) { Object.new }
  let(:amount) { Object.new }
  let(:account_response) { sample_find_account_response(true) }
  let(:find_params) { {'customer' => customer, 'identifier' => identifier} }
  let(:create_params) { {'customer' => customer, 'identifier' => identifier, 'email' => email} }
  let(:fund_params) { {'amount' => amount, 'client_ip' => client_ip, 'cc_token' => cc_token, 'security_code' => security_code, 'customer' => 'bonusly', 'account_identifier' => 'test1'} }
  let(:register_credit_card_params) { {'client_ip' => client_ip, 'credit_card' => credit_card, 'customer' => 'bonusly', 'account_identifier' => 'test1'} }
  let(:delete_credit_card_params) { {'cc_token' => cc_token, 'customer' => 'bonusly', 'account_identifier' => 'test1'} }

  before do
    expect(Tangocard::Raas).to receive(:show_account).with(find_params) { account_response }
    @account = Tangocard::Account.find(customer, identifier)
  end

  describe 'class methods' do
    describe 'self.find' do
      context 'find succeeds' do
        let(:response) { sample_find_account_response(true) }

        before do
          expect(Tangocard::Raas).to receive(:show_account).with(find_params) { response }
        end

        it 'should find the account' do
          expect(Tangocard::Account).to receive(:new).with(response.parsed_response['account']) { true }
          lambda{ Tangocard::Account.find(customer, identifier) }.should_not raise_error
        end
      end

      context 'find fails' do
        let(:response) { sample_find_account_response(false) }

        before do
          expect(Tangocard::Raas).to receive(:show_account).with(find_params) { response }
        end

        it 'should throw an exception' do
          lambda{ Tangocard::Account.find(customer, identifier)}.should raise_error
        end
      end
    end

    describe 'self.create' do
      context 'create succeeds' do
        let(:response) { sample_create_account_response(true) }

        before do
          expect(Tangocard::Raas).to receive(:create_account).with(create_params) { response }
        end

        it 'should create the account and initialize an account object' do
          expect(Tangocard::Account).to receive(:new).with(response.parsed_response['account']) { true }
          lambda{ Tangocard::Account.create(customer, identifier, email) }.should_not raise_error
        end
      end

      context 'create fails' do
        let(:response) { sample_create_account_response(false) }

        before do
          expect(Tangocard::Raas).to receive(:create_account).with(create_params) { response }
        end

        it 'should throw an exception' do
          lambda{ Tangocard::Account.create(customer, identifier, email) }.should raise_error
        end
      end
    end

    describe 'self.find_or_create' do
      it 'should find the customer' do
        expect(Tangocard::Account).to receive(:find).with(customer, identifier) { true }
        Tangocard::Account.find_or_create(customer, identifier, email).should be true
      end

      it 'should create the customer if find fails' do
        expect(Tangocard::Account).to receive(:find).with(customer, identifier) do
          raise Tangocard::AccountNotFoundException, 'Tangocard - Error finding account:'
        end
        expect(Tangocard::Account).to receive(:create).with(customer, identifier, email) { true }
        Tangocard::Account.find_or_create(customer, identifier, email).should be true
      end
    end
  end

  #@customer = params['customer']
  #@email = params['email']
  #@identifier = params['identifier']
  #@available_balance = params['available_balance'].to_i
  describe 'instance methods' do
    describe 'initialize' do
      let(:params) { Object.new }

      it 'should initialize ivars from the parameters' do
        expect(params).to receive(:[]).with('customer') { customer }
        expect(params).to receive(:[]).with('email') { email }
        expect(params).to receive(:[]).with('identifier') { identifier }
        expect(params).to receive(:[]).with('available_balance') { available_balance }
        expect(available_balance).to receive(:to_i) { 1 }
        Tangocard::Account.send(:new, params)
      end
    end

    describe 'register_credit_card' do
      before do
        expect(Tangocard::Raas).to receive(:register_credit_card).with(register_credit_card_params) { response }
      end

      context 'register_credit_card succeeds' do
        let(:response) { sample_register_credit_card_response(true) }

        it 'should register the credit card' do
          response = @account.register_credit_card(client_ip, credit_card)
          response.should be_success
          expect(response.parsed_response['cc_token']).to eq '33041234'
        end
      end

      context 'register_credit_card fails' do
        let(:response) { sample_register_credit_card_response(false) }

        it 'return a Tangocard::Response with success? == false' do
          response = @account.register_credit_card(client_ip, credit_card)
          expect(response.success?).to be false
          expect(response.denial_code).not_to be nil
          expect(response.denial_message).not_to be nil
        end
      end
    end

    describe 'cc_fund' do
      before do
        expect(Tangocard::Raas).to receive(:cc_fund_account).with(fund_params) { response }
      end

      context 'cc_fund succeeds' do
        let(:response) { sample_fund_account_response(true) }

        it 'should fund the account' do
          response = @account.cc_fund(amount, client_ip, cc_token, security_code)
          response.parsed_response['fund_id'].should eq('RF13-09261098-12')
        end
      end

      context 'cc_fund fails' do
        let(:response) { sample_fund_account_response(false) }

        it 'return a Tangocard::Response with success? == false' do
          response = @account.cc_fund(amount, client_ip, cc_token, security_code)
          expect(response.success?).to be false
          expect(response.error_message).not_to be nil
          expect(response.invalid_inputs).not_to be nil
        end
      end
    end

    describe 'delete_credit_card' do
      before do
        expect(Tangocard::Raas).to receive(:delete_credit_card).with(delete_credit_card_params) { response }
      end

      context 'delete_credit_card succeeds' do
        let (:response) { sample_delete_credit_card_response(true) }

        it 'should delete the credit card' do
          @account.delete_credit_card(cc_token).should be_success
        end
      end

      context 'delete_credit_card fails' do
        let (:response) { sample_delete_credit_card_response(false) }

        it 'return a Tangocard::Response with success? == false' do
          response = @account.delete_credit_card(cc_token)
          expect(response.success?).to be false
          expect(response.error_message).not_to be nil
        end
      end
    end
  end
end
