# frozen_string_literal: true

require_relative '../common/api_helpers.rb'
require_relative '../common/assertions.rb'

#------ Contains all auth http requests ------
class Auth
  include ApiHelpers
  include ExpectHelpers
  AUTH_URL = CONFIG['API_URL'] + '/auth'

  attr_accessor :refresh_token, :auth_token, :response

  def auth_network_healthcheck
    do_http_request(
      method: 'GET',
      url: AUTH_URL + '/healthcheck/network'
    )
  end

  # ------ Returns a JWT token in the body ---------------
  def auth_password_healthcheck(payload)
    do_http_request(
      method: 'POST',
      url: AUTH_URL + '/healthcheck/oauth/token',
      headers: {
        'Content-Type' => 'application/x-www-form-urlencoded',
        'Accept' => 'application/json',
        'X-Header' => ''
      },
      payload: payload,
      typeconsistent: true
    )
  end

  def jwt_token_post(payload)
    do_http_request(
      method: 'POST',
      url: AUTH_URL + '/v2/oauth/token',
      headers: {
        'Content-Type' => 'application/x-www-form-urlencoded',
        'Accept' => 'application/json',
        'X-Header' => ''
      },
      payload: payload,
      typeconsistent: true
    )
  end
end
