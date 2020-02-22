# frozen_string_literal: true

require 'json'
require_relative '../../common/data_helpers.rb'
require_relative '../auth.rb'
require_relative '../auth_payloads.rb'
include DataHelpers

auth = Auth.new
data = AuthData.new

describe 'AuthTest' do
  describe 'Get Network Healthcheck' do
    it 'Returns 204' do
      expect(auth.auth_network_healthcheck.code).to eq(204)
    end
  end

  describe 'Get Password Healthcheck' do
    it 'Returns 200' do
      auth.response = auth.auth_password_healthcheck(data.password_healthcheck_payload)
      expect(auth.response.code).to eq(200)
    end

    it 'Returns a JWT' do
      expect(auth.response.hash_body['access_token']).to_not be_nil
    end
  end

  describe 'Send Invalid Username' do
    it 'Returns 401' do
      auth.response = auth.jwt_token_post(data.invalid_username_payload)
      expect(auth.response.code).to eq(401)
    end
  end

  describe 'Send Invalid Password' do
    it 'Returns 401' do
      auth.response = auth.jwt_token_post(data.invalid_password_payload)
      expect(auth.response.code).to eq(401)
    end
  end

  describe 'Get Auth Token' do
    it 'Returns 200' do
      auth.response = auth.jwt_token_post(data.auth_token_payload)
      auth.refresh_token = auth.response.hash_body['refresh_token']
      expect(auth.response.code).to eq(200)
    end

    it 'Returns a JWT' do
      expect(auth.response.hash_body['access_token']).to_not be_nil
    end

    it 'JWT Expires in 5 minutes' do
      expect(auth.response.hash_body['expires_in']).to eq(300)
    end

    it 'Returns a refresh token' do
      expect(auth.response.hash_body['refresh_token']).to_not be_nil
    end
  end

  describe 'Refresh Token Grant' do
    it 'Returns 200' do
      auth.response = auth.jwt_token_post(
        grant_type: 'refresh_token',
        refresh_token: auth.refresh_token
      )
      expect(auth.response.code).to eq(200)
    end

    it 'Returns a New Refresh Token' do
      expect(auth.response.hash_body['refresh_token']).not_to eq(auth.refresh_token)
    end
  end

    it 'JWT Expires in 5 Minutes' do
      expect(auth.response.hash_body['expires_in']).to eq(300)
    end

    it 'Returns a Refresh Token' do
      expect(auth.response.hash_body['refresh_token']).to_not be_nil
    end
  end
end
