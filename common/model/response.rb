# frozen_string_literal: true

class Response
  attr_reader :body, :code, :response_time, :headers, :cookies, :hash_body

  def initialize(response)
    @body = response.body
    @code = response.code
    @response_time = (response.duration * 1000).round
    @headers = response.headers
    @cookies = response.cookies
    @hash_body = !@headers[:content_type].nil? && @headers[:content_type].downcase.include?('application/json') && !response.body.empty? ? JSON.parse(response.body) : response.body
  end
end
