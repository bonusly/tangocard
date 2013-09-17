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
    it "should set the raw_response ivar on initialize" do
      @response.raw_response.should == raw_response
    end
  end

  describe "parsed_response" do
    it "should return the parsed response from the raw_response" do
      mock(raw_response).parsed_response { parsed_response }
      @response.parsed_response.should == parsed_response
    end
  end

  describe "code" do
    it "should return the code from the raw_response" do
      mock(raw_response).code { code }
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
