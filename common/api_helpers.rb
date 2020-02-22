# frozen_string_literal: true

require 'uri'
require 'net/http'
require 'json'
require_relative './logger.rb'
require_relative './model/response.rb'
require 'colorize'
require 'rest-client'
require_relative '../spec_helper.rb'

module ApiHelpers
  def do_http_request(args = {})
    args[:verify_ssl] = false

    unless args.key?(:typeconsistent)
      unless !args.key?(:payload)
        args[:payload] = args[:payload].to_json if !args[:payload].instance_of? String
      end
    end

    puts "== http request ======================================================>".green
    Logger.log.info "Making #{args[:method].upcase} Request to #{args[:url]} with headers: #{args[:headers]} with payload: #{args[:payload]}"
    begin
      response = RestClient::Request.execute(
        method: args[:method].to_sym,
        url: args[:url],
        headers: args[:headers],
        payload: args[:payload]
      )
      response = Response.new(response)
      Logger.log.info "Response took: #{response.response_time}ms - Body: #{response.body}"
      send_latency_metric(args[:url], response.response_time)
      return response
    rescue RestClient::ExceptionWithResponse => e
      Logger.log.error "Error calling #{args[:url]}: #{e} - #{e.response}"
      return e.response
    end
  end

  def payload_builder(payload, args)
    if args.any?
      args.each do |key, val|
        payload[key.to_s] = val
      end
    end
    payload
  end

  def send_latency_metric(url, response_time)
    return unless !ENV['TEST_NAME'].nil?
    api_key = ENV['GRAPHITE_API']
    url = url.partition("//").last.tr("/", "_").tr(".", "_")
    conn = TCPSocket.new 'url', 2003
    body = "QA.#{ENV['TEST_NAME']}.#{url}.LATENCY #{response_time}\n"
    conn.puts "#{api_key}.#{body}"
    conn.close
    nil
  end
end
