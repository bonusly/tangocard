class Tangocard::Response
  attr_reader :parsed_response, :code

  def initialize(raw_response)
    @parsed_response = raw_response.parsed_response
    @code = raw_response.code
  end

  def success?
    parsed_response['success']
  end

  def error_message
    parsed_response['error_message']
  end

  def invalid_inputs
    parsed_response['invalid_inputs']
  end
end