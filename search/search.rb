# frozen_string_literal: true

require_relative '../common/api_helpers.rb'

module Search
  class << self
    include ApiHelpers
    include Enumerable

    def find_products(params)
      context = determine_context(params)
      do_http_request(
        method: :post,
        url: CONFIG['API_URL'] + '/search',
        headers: {
          content_type: :json
        },
        payload: {
          query: query,
          params: params
        }
      )
    end

    def each_page_for(params)
      page = 0
      response = find_products(params)
      hits = JSON.parse(response.body)['hits'] if response.code == 200
      until hits.nil? || hits.empty?
        yield hits
        page += 1
        response = find_products(params)
        hits = JSON.parse(response.body)['hits'] if response.code == 200
      end
    end

    private

    def determine_context(params))
      {

      }
    end
  end
end
