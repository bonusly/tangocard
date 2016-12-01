require 'spec_helper'

describe Tangocard::ExchangeRate do
  include TangocardHelpers

  describe 'class methods' do
    describe 'self.clear_cache!' do
      it 'should call Tangocard::Raas.clear_cache!' do
        expect(Tangocard::Raas).to receive(:clear_cache!) { true }
        Tangocard::Brand.clear_cache!
      end
    end

    describe 'self.timestamp' do
      before do
        allow(Tangocard::Raas).to receive(:rewards_index) { double(parsed_response: sample_parsed_response) }
      end

      it 'should return timestamp' do
        expect(Tangocard::ExchangeRate.timestamp).to eq 1456956187
      end
    end

    describe 'self.all' do
      before do
        allow(Tangocard::Raas).to receive(:rewards_index) { double(parsed_response: sample_parsed_response) }
      end

      it 'should return an array of Tangocard::ExchangeRate objects' do
        all_rates = Tangocard::ExchangeRate.all
        all_rates.should be_a(Array)
        expect(all_rates.map(&:class).uniq.count).to eq 1
        expect(all_rates.map(&:class).uniq.first).to eq Tangocard::ExchangeRate
      end
    end

    describe 'self.find' do
      before do
        allow(Tangocard::Raas).to receive(:rewards_index) { double(parsed_response: sample_parsed_response) }
      end

      it 'should return exchange rate which matches currency_code' do
        expect(Tangocard::ExchangeRate.find('EUR').class).to eq Tangocard::ExchangeRate
        expect(Tangocard::ExchangeRate.find('EUR').rate).to eq 0.8887
      end
    end

    describe 'self.populate_money_rates' do
      it 'should set all available exchange rate for Money' do
        allow(Tangocard::ExchangeRate).to receive(:all) { [Tangocard::ExchangeRate.new('EUR', 2)] }
        expect(Money).to receive(:add_rate).with('EUR', 'USD', 0.50)
        expect(Tangocard::ExchangeRate.populate_money_rates).to eq true
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
        expect(exchange_rate.currency_code).to eq 'USD'
      end

      it 'should initialize the rate' do
        exchange_rate = Tangocard::ExchangeRate.new(*params)
        expect(exchange_rate.rate).to eq 5.0
      end
    end

    describe 'inverse_rate' do
      it 'should return an inverse calculated rate' do
        exchange_rate = Tangocard::ExchangeRate.new(*params)
        expect(exchange_rate.inverse_rate).to eq 0.2
      end
    end
  end
end
