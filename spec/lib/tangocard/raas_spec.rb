require 'spec_helper'

describe Tangocard::Raas do
  let(:name) { 'name' }
  let(:key) { 'key' }
  let(:params) { Object.new }
  let(:json) { Object.new }
  let(:basic_auth_param) { {basic_auth: {username: name, password: key}} }
  let(:raw_response) { Object.new }
  let(:response) { Object.new }

  before(:each) do
    Tangocard.configure do |c|
      c.name = name
      c.key = key
    end
    @endpoint = Tangocard.configuration.base_uri + '/raas/v1.1'
  end

  describe 'private methods' do
    describe 'self.basic_auth_param' do
      it 'should build a basic_auth hash using the tangocard api credentials' do
        Tangocard::Raas.send(:basic_auth_param).should == basic_auth_param
      end
    end
  end

  describe 'class methods' do
    before do
      stub(Tangocard::Response).new(raw_response) { response }
    end

    describe 'self.create_account' do
      it 'should POST to the RaaS API with appropriate params and wrap the result in a Tangocard::Response object' do
        mock(params).to_json { json }
        mock(Tangocard::Raas).post(@endpoint + '/accounts', {:body => json}.merge(basic_auth_param)) { raw_response }
        Tangocard::Raas.create_account(params).should == response
      end
    end

    describe 'self.show_account' do
      it 'should GET to the RaaS API with appropriate params and wrap the result in a Tangocard::Response object' do
        mock(params).[]('customer') { 'customer' }
        mock(params).[]('identifier') { 'identifier' }
        mock(Tangocard::Raas).get(@endpoint + '/accounts/customer/identifier', basic_auth_param) { raw_response }
        Tangocard::Raas.show_account(params).should == response
      end
    end

    describe 'self.fund_account' do
      it 'should POST to the RaaS API with appropriate params and wrap the result in a Tangocard::Response object' do
        mock(params).to_json { json }
        mock(Tangocard::Raas).post(@endpoint + '/funds', {body: json}.merge(basic_auth_param)) { raw_response }
        Tangocard::Raas.fund_account(params).should == response
      end
    end

    describe 'self.cc_fund_account' do
      it 'should POST to the RaaS API with appropriate params and wrap the result in a Tangocard::Response object' do
        mock(params).to_json { json }
        mock(Tangocard::Raas).post(@endpoint + '/cc_fund', {body: json}.merge(basic_auth_param)) { raw_response }
        Tangocard::Raas.cc_fund_account(params).should == response
      end
    end

    describe 'self.register_credit_card' do
      it 'should POST to the RaaS API with appropriate params and wrap the result in a Tangocard::Response object' do
        mock(params).to_json { json }
        mock(Tangocard::Raas).post(@endpoint + '/cc_register', {body: json}.merge(basic_auth_param)) { raw_response }
        Tangocard::Raas.register_credit_card(params).should == response
      end
    end

    describe 'self.rewards_index' do
      context 'use_cache == true' do
        before do
          Tangocard.configure do |c|
            c.use_cache = true
          end
        end

        it 'should do the GET request once, then hit cache' do
          mock(Tangocard::Raas).get(@endpoint + '/rewards', basic_auth_param).times(2) { raw_response }
          Tangocard::Raas.rewards_index.should == response
          Tangocard::Raas.rewards_index.should == response
          Tangocard::Raas.clear_cache!
          Tangocard::Raas.rewards_index.should == response
          Tangocard::Raas.rewards_index.should == response
        end
      end

      context 'use_cache == false' do
        before do
          Tangocard.configure do |c|
            c.use_cache = false
          end
        end

        it 'should do the GET request once, then hit cache' do
          mock(Tangocard::Raas).get(@endpoint + '/rewards', basic_auth_param).times(2) { raw_response }
          Tangocard::Raas.rewards_index.should == response
          Tangocard::Raas.rewards_index.should == response
        end
      end
    end

    describe 'self.create_order' do
      it 'should POST to the RaaS API with appropriate params and wrap the result in a Tangocard::Response object' do
        mock(params).to_json { json }
        mock(Tangocard::Raas).post(@endpoint + '/orders', {body: json}.merge(basic_auth_param)) { raw_response }
        Tangocard::Raas.create_order(params).should == response
      end
    end

    describe 'self.show_order' do
      it 'should GET to the RaaS API with appropriate params and wrap the result in a Tangocard::Response object' do
        mock(params).[]('order_id') { 'order_id' }
        mock(Tangocard::Raas).get(@endpoint + '/orders/order_id', basic_auth_param) { raw_response }
        Tangocard::Raas.show_order(params).should == response
      end
    end

    # Tangocard::Response.new(self.class.get('/raas/v1/orders#{query_string}', basic_auth_param))
    describe 'self.orders_index' do
      it 'should GET to the RaaS API with params converted into a query string and wrap the result in a Tangocard::Response object' do
        mock(Tangocard::Raas).get(@endpoint + '/orders?foo=bar', basic_auth_param) { raw_response }
        Tangocard::Raas.orders_index({'foo' => 'bar'}).should == response
      end
    end
  end
end
