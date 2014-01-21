require 'spec_helper'

describe Tangocard::Response do
  let(:code) { Object.new }
  let(:success) { Object.new }
  let(:error_message) { Object.new }
  let(:parsed_response) { {'success' => success, 'error_message' => error_message} }
  let(:raw_response) { OpenStruct.new(:code => code, :parsed_response => parsed_response) }

  before do
    @response = Tangocard::Response.new(raw_response)
  end

  describe "inialize" do
    it "should set the ivars on initialize" do
      @response.parsed_response.should == parsed_response
      @response.code.should == code
    end
  end

  describe "success?" do
    it "should return the value of the 'success' key from the parsed_response" do
      @response.success?.should == success
    end
  end

  describe "error_message" do
    it "should return the value of the 'error_message' key from the parsed_response" do
      @response.error_message.should == error_message
    end
  end
end
