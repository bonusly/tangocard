class Tangocard::Response
  attr_reader :raw_response

  def initialize(raw_response)
    @raw_response = raw_response
  end

  def parsed_response
    raw_response.parsed_response
  end

  def code
    raw_response.code
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