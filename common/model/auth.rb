# frozen_string_literal: true

require 'securerandom'

class Auth
  attr_accessor :uuid, :password, :grant_type, :os, :headers, :username, :request_body, :token

  def initialize(args = {})
    @grant_type = args[:grant_type] || 'password'
    @headers = args[:headers] || { 'Content-Type': 'application/x-www-form-urlencoded', 'X-Header': '' }
    @os = args[:os] || 'ruby_framework'
    @password = args[:password] || 'password'
    @uuid = args[:uuid] || SecureRandom.uuid.to_s
    @username = args[:username] || 'email'
    @client_id = "#{@os}-#{@uuid}"
    @request_body = "password=#{@password}&grant_type=#{@grant_type}&client_id=#{@client_id}&username=#{@username}"
  end
end
