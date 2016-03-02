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
          @reward.description.should == @reward_params['description']
          @reward.sku.should == @reward_params['sku']
          @reward.is_variable.should == @reward_params['is_variable']
          @reward.currency_code.should == @reward_params['currency_code']
          @reward.denomination.should == @reward_params['denomination'].to_i
          @reward.available.should == @reward_params['available']
          @reward.min_price.should == @reward_params['min_price'].to_i
          @reward.max_price.should == @reward_params['max_price'].to_i
        end
      end

      describe 'variable_price?' do
        it 'should be false' do
          @reward.variable_price?.should be_false
        end
      end

      describe 'purchasable?' do
        it 'should return false if unavailable' do
          stub(@reward).available { false }
          @reward.purchasable?(cents).should be_false
        end

        it 'should be true if denomination <= balance' do
          mock(@reward).denomination.mock!.<=(cents) { true }
          @reward.purchasable?(cents).should be_true
        end

        it 'should be false if denomination > balance' do
          mock(@reward).denomination.mock!.<=(cents) { false }
          @reward.purchasable?(cents).should be_false
        end
      end

      describe 'to_money' do
        it 'should return nil unless valid field name is given' do
          @reward.to_money(:asdgasdga).should be_nil
        end

        it 'should properly format the unit_price' do
          mock(@reward).send(:denomination) { cents }
          @reward.to_money(:denomination).format.should == '$5.00'
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
          @reward.description.should == @reward_params['description']
          @reward.sku.should == @reward_params['sku']
          @reward.is_variable.should == @reward_params['is_variable']
          @reward.currency_code.should == @reward_params['currency_code']
          @reward.denomination.should == @reward_params['denomination'].to_i
          @reward.available.should == @reward_params['available']
          @reward.min_price.should == @reward_params['min_price'].to_i
          @reward.max_price.should == @reward_params['max_price'].to_i
        end
      end

      describe 'variable_price?' do
        it 'should be true' do
          @reward.variable_price?.should be_true
        end
      end

      describe 'purchasable?' do
        it 'should return false if unavailable' do
          stub(@reward).available { false }
          @reward.purchasable?(cents).should be_false
        end

        it 'should be true if min_price <= balance' do
          mock(@reward).min_price.mock!.<=(cents) { true }
          @reward.purchasable?(cents).should be_true
        end

        it 'should be false if min_price > balance' do
          mock(@reward).min_price.mock!.<=(cents) { false }
          @reward.purchasable?(cents).should be_false
        end
      end

      describe 'to_money' do
        it 'should return nil unless valid field name is given' do
          @reward.to_money(:asdgasdga).should be_nil
        end

        it 'should properly format the min_price' do
          mock(@reward).send(:min_price) { cents }
          @reward.to_money(:min_price).format.should == '$5.00'
        end

        it 'should properly format the max_price' do
          mock(@reward).send(:max_price) { cents }
          @reward.to_money(:max_price).format.should == '$5.00'
        end
      end
    end
  end

end
