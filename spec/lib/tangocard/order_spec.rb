require 'spec_helper'

describe Tangocard::Order do
  include TangocardHelpers

  describe "class methods" do
    describe "self.all" do
      let(:params) { Object.new }
      let(:success_response) { sample_order_index_response(true) }
      let(:fail_response) { sample_order_index_response(false) }

      it "should return an array of Tangocard::Order objects if successful" do
        mock(Tangocard::Raas).orders_index(params) { success_response }
        mock(Tangocard::Order).new(success_response.parsed_response['orders'].first) { true }
        Tangocard::Order.all(params).should == [true]
      end

      it "should return an empty array if unsuccessful" do
        mock(Tangocard::Raas).orders_index(params) { fail_response }
        Tangocard::Order.all(params).should == []
      end
    end

    describe "self.find" do
      let(:order_id) { Object.new }
      let(:success_response) { sample_find_order_response(true) }
      let(:fail_response) { sample_find_order_response(false) }

      it "should return a Tangocard::Order object if successful" do
        mock(Tangocard::Raas).show_order({'order_id' => order_id}) { success_response }
        mock(Tangocard::Order).new(success_response.parsed_response['order']) { true }
        Tangocard::Order.find(order_id).should be_true
      end

      it "should throw a Tangocard::OrderNotFoundException if failed" do
        mock(Tangocard::Raas).show_order({'order_id' => order_id}) { fail_response }
        lambda{ Tangocard::Order.find(order_id) }.should raise_error(Tangocard::OrderNotFoundException)
      end
    end

    describe "self.create" do
      let(:params) { Object.new }
      let(:success_response) { sample_create_order_response(true) }
      let(:fail_response) { sample_create_order_response(false) }

      it "should return at Tangocard::Order object if successful" do
        mock(Tangocard::Raas).create_order(params) { success_response }
        mock(Tangocard::Order).new(success_response.parsed_response['order']) { true }
        Tangocard::Order.create(params).should be_true
      end

      it "should throw a Tangocard::OrderCreateFailedException if failed" do
        mock(Tangocard::Raas).create_order(params) { fail_response }
        lambda{ Tangocard::Order.create(params) }.should raise_error(Tangocard::OrderCreateFailedException)
      end
    end
  end

  describe "instance methods" do
    describe "initialize" do
      let(:params) { Object.new }

      it "should set the attributes on the object" do
        mock(params).[]('order_id') { 'order_id'}
        mock(params).[]('account_identifier') { 'account_identifier'}
        mock(params).[]('customer') { 'customer'}
        mock(params).[]('sku') { 'sku'}
        mock(params).[]('amount') { 'amount'}
        mock(params).[]('reward_message') { 'reward_message'}
        mock(params).[]('reward_subject') { 'reward_subject'}
        mock(params).[]('reward_from') { 'reward_from'}
        mock(params).[]('delivered_at') { 'delivered_at'}
        mock(params).[]('recipient') { 'recipient'}
        mock(params).[]('reward') { 'reward'}

        Tangocard::Order.send(:new, params)
      end
    end

    describe "reward" do
      pending "TODO"
    end

    describe "identifier" do
      pending "TODO"
    end
  end
end