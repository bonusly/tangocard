require 'spec_helper'

describe Tangocard::Raas do
  let(:name) { 'name' }
  let(:key) { 'key' }
  let(:params) { Object.new }
  let(:json) { Object.new }
  let(:basic_auth_param) { { basic_auth: { username: name, password: key } } }
  let(:response) { Object.new }
  let(:raw_response) { double(parsed_response: response, code: 200) }

  before(:each) do
    Tangocard.configure do |c|
      c.name = name
      c.key = key
      c.use_cache = false
    end
  end

  describe 'private methods' do
    describe 'self.basic_auth_param' do
      it 'should build a basic_auth hash using the tangocard api credentials' do
        expect(Tangocard::Raas.send(:basic_auth_param)).to eq basic_auth_param
      end
    end

    describe 'self.get_request' do
      it 'should send a get request to the correct url with authentication params' do
        expect(Tangocard::Raas).to receive(:get).with('https://sandbox.tangocard.com/raas/v1.1/rewards', basic_auth_param)
        Tangocard::Raas.get_request('/rewards')
      end
    end

    describe 'self.post_request' do
      it 'should send a get request to the correct url with authentication params' do
        params = { body: '' }
        expect(Tangocard::Raas).to receive(:post).with('https://sandbox.tangocard.com/raas/v1.1/accounts', params.merge(basic_auth_param))
        Tangocard::Raas.post_request('/accounts', params)
      end
    end
  end

  describe 'class methods' do
    before do
      allow(params).to receive(:to_json) { json }
    end

    describe 'self.create_account' do
      it 'should POST to the RaaS API with appropriate params and wrap the result in a Tangocard::Response object' do
        expect(Tangocard::Raas).to receive(:post_request).with('/accounts', { body: json }) { raw_response }
        expect(Tangocard::Raas.create_account(params).parsed_response).to eq response
      end
    end

    describe 'self.show_account' do
      it 'should GET to the RaaS API with appropriate params and wrap the result in a Tangocard::Response object' do
        expect(params).to receive(:[]).with('customer') { 'customer' }
        expect(params).to receive(:[]).with('identifier') { 'identifier' }
        expect(Tangocard::Raas).to receive(:get_request).with('/accounts/customer/identifier') { raw_response }
        expect(Tangocard::Raas.show_account(params).parsed_response).to eq response
      end
    end

    describe 'self.cc_fund_account' do
      it 'should POST to the RaaS API with appropriate params and wrap the result in a Tangocard::Response object' do
        expect(Tangocard::Raas).to receive(:post_request).with('/cc_fund', { body: json }) { raw_response }
        expect(Tangocard::Raas.cc_fund_account(params).parsed_response).to eq response
      end
    end

    describe 'self.register_credit_card' do
      it 'should POST to the RaaS API with appropriate params and wrap the result in a Tangocard::Response object' do
        expect(Tangocard::Raas).to receive(:post_request).with('/cc_register', { body: json }) { raw_response }
        expect(Tangocard::Raas.register_credit_card(params).parsed_response).to eq response
      end
    end

    describe 'self.rewards_index' do
      context 'use_cache == true' do

        before do
          expect(Tangocard::Raas).to receive(:get_request).with('/rewards') { raw_response }

          Tangocard.configure do |c|
            c.use_cache = true
          end
        end

        it 'should not do any get requests if the cache is warm' do
          expect(Tangocard::Raas).not_to receive(:get_request).with('/rewards')
          Tangocard::Raas.rewards_index
        end
      end

      context 'use_cache == false' do
        it 'should do the GET request once, then hit cache' do
          expect(Tangocard::Raas).to receive(:get_request).with('/rewards').twice { raw_response }
          expect(Tangocard::Raas.rewards_index.parsed_response).to eq response
          expect(Tangocard::Raas.rewards_index.parsed_response).to eq response
        end
      end
    end

    describe 'self.create_order' do
      it 'should POST to the RaaS API with appropriate params and wrap the result in a Tangocard::Response object' do
        expect(Tangocard::Raas).to receive(:post_request).with('/orders', { body: json }) { raw_response }
        expect(Tangocard::Raas.create_order(params).parsed_response).to eq response
      end
    end

    describe 'self.show_order' do
      it 'should GET to the RaaS API with appropriate params and wrap the result in a Tangocard::Response object' do
        expect(params).to receive(:[]).with('order_id') { 'order_id' }
        expect(Tangocard::Raas).to receive(:get_request).with('/orders/order_id') { raw_response }
        expect(Tangocard::Raas.show_order(params).parsed_response).to eq response
      end
    end

    describe 'self.orders_index' do
      it 'should GET to the RaaS API with params converted into a query string and wrap the result in a Tangocard::Response object' do
        expect(Tangocard::Raas).to receive(:get_request).with('/orders?foo=bar') { raw_response }
        expect(Tangocard::Raas.orders_index({ foo: 'bar' }).parsed_response).to eq response
      end
    end
  end
end
