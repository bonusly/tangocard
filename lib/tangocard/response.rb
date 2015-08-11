class Tangocard::Response
  attr_reader :parsed_response, :code

  def initialize(raw_response)
    @parsed_response = raw_response.parsed_response
    @code = raw_response.code
  end

  def success?
    parsed_response['success'] rescue false
  end

  def error_message
    parsed_response['error_message'] rescue 'UNKNOWN ERROR'
  end

  def denial_message
    parsed_response['denial_message'] rescue 'UNKNOWN ERROR'
  end

  def invalid_inputs
    parsed_response['invalid_inputs'] rescue 'UNKNOWN INVALID INPUTS'
  end
end
