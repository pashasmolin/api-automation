# frozen_string_literal: true

require 'csv'
require_relative '../common/api_helpers.rb'
require_relative '../common/data_helpers.rb'
require_relative '../common/queries.rb'

class Autocomplete
  include ApiHelpers
  include DataHelpers
  attr_accessor :autocomplete_url, :response_data, :response, :popular_searches, :stores

  def initialize
    @schema = DataHelpers.file_to_json('file/schema.json')
    @autocomplete_url = CONFIG['AUTOCOMPLETE_URL']
    @response_data = nil
    @response = nil
    @context = DataHelpers.query()
    @popular_searches = CSV.read("autocomplete/data/popular_searches.csv")
    @stores = []
  end

  def autocomplete_get(url)
    do_http_request(method: 'GET',
                    url: url)
  end

  def autocomplete_post(url, args = {})
    request_body = args[:payload] || payload_builder(DataHelpers.file_to_json('autocomplete/data/requests/autocomplete.json'), args)
    do_http_request(method: 'POST',
                    url: url,
                    payload: request_body)
  end

  def all_suggestions_include(fragment, response)
    match = false
    @suggestions.clear
    response.each_index do |i|
      @suggestions << response[i]['term'].downcase
    end
    @suggestions.each do |term|
      if term.index fragment
        match = true
      else
        match = "<#{term}> suggestion did not include fragment <#{fragment}>"
        break
      end
    end
    match
  end
end
