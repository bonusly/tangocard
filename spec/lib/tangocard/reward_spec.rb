require 'spec_helper'

describe Tangocard::Brand do
  include TangocardHelpers

  let(:cents) { 500 }

  describe 'instance methods' do
    context 'fixed price' do
      before do
        @reward_params = sample_brand_fixed['rewards'].first
        @reward = Tangocard::Reward.new(@reward_params)
      end

      describe 'initialize' do
        it 'should set instance variables from parameters' do
          expect(@reward.description).to eq @reward_params['description']
          expect(@reward.sku).to eq @reward_params['sku']
          expect(@reward.is_variable).to eq @reward_params['is_variable']
          expect(@reward.currency_code).to eq @reward_params['currency_code']
          expect(@reward.denomination).to eq @reward_params['denomination'].to_i
          expect(@reward.available).to eq @reward_params['available']
          expect(@reward.min_price).to eq @reward_params['min_price'].to_i
          expect(@reward.max_price).to eq @reward_params['max_price'].to_i
          expect(@reward.countries).to eq @reward_params['countries']
        end
      end

      describe 'variable_price?' do
        it 'should be false' do
          expect(@reward.variable_price?).to be false
        end
      end

      describe 'purchasable?' do
        it 'should return false if unavailable' do
          allow(@reward).to receive(:available) { false }
          expect(@reward.purchasable?(cents)).to be false
        end

        it 'should be true if denomination <= balance' do
          expect(@reward.purchasable?(@reward.denomination + 100)).to be true
        end

        it 'should be false if denomination > balance' do
          expect(@reward.purchasable?(@reward.denomination - 100)).to be false
        end
      end

      describe 'to_money' do
        it 'should return nil unless valid field name is given' do
          expect(@reward.to_money(:asdgasdga)).to be nil
        end

        it 'should properly format the unit_price' do
          expect(@reward).to receive(:send).with(:denomination) { cents }
          expect(@reward.to_money(:denomination).format).to eq '$5.00'
        end
      end
    end

    context 'variable price' do
      before do
        @reward_params = sample_brand_variable['rewards'].first
        @reward = Tangocard::Reward.new(@reward_params)
      end

      describe 'initialize' do
        it 'should set instance variables from parameters' do
          expect(@reward.description).to eq @reward_params['description']
          expect(@reward.sku).to eq @reward_params['sku']
          expect(@reward.is_variable).to eq @reward_params['is_variable']
          expect(@reward.currency_code).to eq @reward_params['currency_code']
          expect(@reward.denomination).to eq @reward_params['denomination'].to_i
          expect(@reward.available).to eq @reward_params['available']
          expect(@reward.min_price).to eq @reward_params['min_price'].to_i
          expect(@reward.max_price).to eq @reward_params['max_price'].to_i
          expect(@reward.countries).to eq @reward_params['countries']
        end
      end

      describe 'variable_price?' do
        it 'should be true' do
          expect(@reward.variable_price?).to be true
        end
      end

      describe 'purchasable?' do
        it 'should return false if unavailable' do
          allow(@reward).to receive(:available) { false }
          expect(@reward.purchasable?(cents)).to be false
        end

        it 'should be true if min_price <= balance' do
          expect(@reward.purchasable?(@reward.min_price + 100)).to be true
        end

        it 'should be false if min_price > balance' do
          expect(@reward.purchasable?(@reward.min_price - 100)).to be false
        end
      end

      describe 'to_money' do
        it 'should return nil unless valid field name is given' do
          expect(@reward.to_money(:asdgasdga)).to be_nil
        end

        it 'should properly format the min_price' do
          expect(@reward).to receive(:send).with(:min_price) { cents }
          expect(@reward.to_money(:min_price).format).to eq '$5.00'
        end

        it 'should properly format the max_price' do
          expect(@reward).to receive(:send).with(:max_price) { cents }
          expect(@reward.to_money(:max_price).format).to eq '$5.00'
        end
      end
    end
  end

end
