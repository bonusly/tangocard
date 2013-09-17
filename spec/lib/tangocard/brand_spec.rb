require 'spec_helper'

describe Tangocard::Brand do
  include TangocardHelpers

  describe "class methods" do
    describe "self.all" do
      context "uncached" do
        before do
          mock(Tangocard::Raas).rewards_index.mock!.parsed_response { sample_parsed_response }
        end

        after do
          Rails.cache.clear
        end

        it "should return an array of Tangocard::Brand objects" do
          all_brands = Tangocard::Brand.all
          all_brands.should be_instance_of Array
          all_brands.map(&:class).uniq.count.should == 1
          all_brands.map(&:class).uniq.first.should == Tangocard::Brand
        end

        it "should cache the result" do
          Tangocard::Brand.all
          Tangocard::Brand.all # 2nd call would fail due to mock above, unless caching is working
        end
      end

      context "cached" do
        before do
          Rails.cache.fetch "tangocard-brands" do
            sample_parsed_response
          end
        end

        after do
          Rails.cache.clear
        end

        it "should not call Tangocard::Raas.rewards_index" do
          dont_allow(Tangocard::Raas).rewards_index
          Tangocard::Brand.all
        end

        it "should return an array of Tangocard::Brand objects" do
          all_brands = Tangocard::Brand.all
          all_brands.should be_instance_of Array
          all_brands.map(&:class).uniq.count.should == 1
          all_brands.map(&:class).uniq.first.should == Tangocard::Brand
        end
      end
    end

    describe "self.default_brands" do
      before do
        stub(Tangocard::Raas).rewards_index.stub!.parsed_response { sample_parsed_response }
        TANGOCARD::DEFAULT_BRANDS = ["Tango Card"]
      end

      it "should return only brands matching TANGOCARD::DEFAULT_BRANDS" do
        Tangocard::Brand.default_brands.count.should == 1
        Tangocard::Brand.default_brands.first.description.should == "Tango Card"
      end
    end

    describe "self.find" do
      before do
        stub(Tangocard::Raas).rewards_index.stub!.parsed_response { sample_parsed_response }
      end

      it "should return the first brand whose description matches the brand_name" do
        Tangocard::Brand.find("Amazon.com").class.should == Tangocard::Brand
        Tangocard::Brand.find("Amazon.com").description.should == "Amazon.com"
      end
    end
  end

  describe "instance methods" do
    let(:description) { Object.new }
    let(:image_url) { Object.new }
    let(:reward) { Object.new }
    let(:params) { {'description' => description, 'image_url' => image_url, 'rewards' => [reward]} }
    let(:variable_brand) { Tangocard::Brand.new(sample_brand_variable) }
    let(:fixed_brand) { Tangocard::Brand.new(sample_brand_fixed) }
    let(:cents) { 500 }

    describe "initialize" do
      it "should initialize the description" do
        stub(Tangocard::Reward).new(reward) { true }
        brand = Tangocard::Brand.new(params)
        brand.description.should == description
      end

      it "should initialize the image_url" do
        stub(Tangocard::Reward).new(reward) { true }
        brand = Tangocard::Brand.new(params)
        brand.image_url.should == image_url
      end

      it "should initialize the reward(s)" do
        mock(Tangocard::Reward).new(reward) { true }
        Tangocard::Brand.new(params)
      end
    end

    describe "image_url" do
      it "should return a local override image, if present" do
        stub(Tangocard::Reward).new(reward) { true }
        stub(TANGOCARD::LOCAL_IMAGES).[](description) { "local" }
        brand = Tangocard::Brand.new(params)
        brand.image_url.should == "local"
      end

      it "should return image_url if no local override image" do
        stub(Tangocard::Reward).new(reward) { true }
        stub(TANGOCARD::LOCAL_IMAGES).[](description) { nil }
        brand = Tangocard::Brand.new(params)
        brand.image_url.should == image_url
      end
    end

    describe "purchasable_rewards" do
      it "should return all purchasable rewards" do
        fixed_brand.rewards.each_with_index do |r, i|
          mock(r).purchasable?(cents) { i.even? }
        end

        purchasable = fixed_brand.purchasable_rewards(cents)
        fixed_brand.rewards.each_with_index do |r, i|
          purchasable.include?(r).should be_true if i.even?
        end
      end
    end

    describe "has_purchasable_rewards?" do
      context "has purchasable rewards" do
        before do
          stub(fixed_brand).purchasable_rewards(cents) { [:a, :b] }
        end

        it "should return true" do
          fixed_brand.has_purchasable_rewards?(cents).should be_true
        end
      end

      context "no purchasable rewards" do
        before do
          stub(fixed_brand).purchasable_rewards(cents) { [] }
        end

        it "should return false" do
          fixed_brand.has_purchasable_rewards?(cents).should be_false
        end
      end
    end

    describe "variable_price?" do
      it "should return true if variable priced rewards are available" do
        variable_brand.variable_price?.should be_true
      end

      it "should return false if no variable priced rewards are available" do
        fixed_brand.variable_price?.should be_false
      end
    end
  end
end