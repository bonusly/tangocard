require 'spec_helper'

describe Tangocard::ExchangeRate do
  include TangocardHelpers

  describe 'class methods' do
    describe 'self.clear_cache!' do
      it 'should call Tangocard::Raas.clear_cache!' do
        mock(Tangocard::Raas).clear_cache! { true }
        Tangocard::Brand.clear_cache!
      end
    end

    describe 'self.timestamp' do
      before do
        stub(Tangocard::Raas).rewards_index.stub!.parsed_response { sample_parsed_response }
      end

      it 'should return timestamp' do
        Tangocard::ExchangeRate.timestamp.should == 1456956187
      end
    end

    describe 'self.all' do
      before do
        stub(Tangocard::Raas).rewards_index.stub!.parsed_response { sample_parsed_response }
      end

      it 'should return an array of Tangocard::ExchangeRate objects' do
        all_rates = Tangocard::ExchangeRate.all
        all_rates.should be_instance_of Array
        all_rates.map(&:class).uniq.count.should == 1
        all_rates.map(&:class).uniq.first.should == Tangocard::ExchangeRate
      end
    end

    describe 'self.find' do
      before do
        stub(Tangocard::Raas).rewards_index.stub!.parsed_response { sample_parsed_response }
      end

      it 'should return exchange rate which matches currency_code' do
        Tangocard::ExchangeRate.find('EUR').class.should == Tangocard::ExchangeRate
        Tangocard::ExchangeRate.find('EUR').rate.should == 0.8887
      end
    end

    describe 'self.populate_money_rates' do
      it 'should set all available exchange rate for Money' do
        stub(Tangocard::ExchangeRate).all { [Tangocard::ExchangeRate.new('EUR', 2)] }
        mock(Money).add_rate('EUR', 'USD', 0.50)
        Tangocard::ExchangeRate.populate_money_rates.should == true
      end
    end
  end

  describe 'instance methods' do
    let(:currency_code) { 'USD' }
    let(:rate) { '5' }
    let(:params) { [currency_code, rate] }

    describe 'initialize' do
      it 'should initialize the currency_code' do
        exchange_rate = Tangocard::ExchangeRate.new(*params)
        exchange_rate.currency_code.should == 'USD'
      end

      it 'should initialize the rate' do
        exchange_rate = Tangocard::ExchangeRate.new(*params)
        exchange_rate.rate.should == 5.0
      end
    end

    describe 'inverse_rate' do
      it 'should return an inverse calculated rate' do
        exchange_rate = Tangocard::ExchangeRate.new(*params)
        exchange_rate.inverse_rate.should == 0.2
      end
    end
  end
end
