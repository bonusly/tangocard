require 'spec_helper'

describe Tangocard::Account do
  include TangocardHelpers

  let(:customer) { Object.new }
  let(:identifier) { Object.new }
  let(:email) { Object.new }
  let(:available_balance) { Object.new }
  let(:find_params) { {'customer' => customer, 'identifier' => identifier} }
  let(:create_params) { {'customer' => customer, 'identifier' => identifier, 'email' => email} }

  describe "class methods" do
    describe "self.find" do
      context "find succeeds" do
        let(:response) { sample_find_account_response(true) }

        before do
          mock(Tangocard::Raas).show_account(find_params) { response }
        end

        it "should find the account" do
          mock(Tangocard::Account).new(response.parsed_response['account']) { true }
          lambda{ Tangocard::Account.find(customer, identifier) }.should_not raise_error
        end
      end

      context "find fails" do
        let(:response) { sample_find_account_response(false) }

        before do
          mock(Tangocard::Raas).show_account(find_params) { response }
        end

        it "should throw an exception" do
          lambda{ Tangocard::Account.find(customer, identifier)}.should raise_error
        end
      end
    end

    describe "self.create" do
      context "create succeeds" do
        let(:response) { sample_create_account_response(true) }

        before do
          mock(Tangocard::Raas).create_account(create_params) { response }
        end

        it "should create the account and initialize an account object" do
          mock(Tangocard::Account).new(response.parsed_response['account']) { true }
          lambda{ Tangocard::Account.create(customer, identifier, email) }.should_not raise_error
        end
      end

      context "create fails" do
        let(:response) { sample_create_account_response(false) }

        before do
          mock(Tangocard::Raas).create_account(create_params) { response }
        end

        it "should throw an exception" do
          lambda{ Tangocard::Account.create(customer, identifier, email) }.should raise_error
        end
      end
    end

    describe "self.find_or_create" do
      it "should find the customer" do
        mock(Tangocard::Account).find(customer, identifier) { true }
        Tangocard::Account.find_or_create(customer, identifier, email).should be_true
      end

      it "should create the customer if find fails" do
        mock(Tangocard::Account).find(customer, identifier) do
          raise Tangocard::AccountNotFoundException, "Tangocard - Error finding account:"
        end
        mock(Tangocard::Account).create(customer, identifier, email) { true }
        Tangocard::Account.find_or_create(customer, identifier, email).should be_true
      end
    end
  end

  #@customer = params['customer']
  #@email = params['email']
  #@identifier = params['identifier']
  #@available_balance = params['available_balance'].to_i
  describe "instance methods" do
    describe "initialize" do
      let(:params) { Object.new }

      it "should initialize ivars from the parameters" do
        mock(params).[]('customer') { customer }
        mock(params).[]('email') { email }
        mock(params).[]('identifier') { identifier }
        mock(params).[]('available_balance') { available_balance }
        mock(available_balance).to_i { 1 }
        Tangocard::Account.send(:new, params)
      end
    end

    describe "fund!" do
      pending "TODO"
    end
  end
end