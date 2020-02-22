# frozen_string_literal: true

require_relative '../search.rb'
require_relative '../../spec_helper.rb'
require_relative '../../common/api_helpers.rb'
require_relative '../../common/data_helpers.rb'
require_relative '../../common/queries.rb'

describe 'Search' do
  before(:all) do
    @shared = OpenStruct.new(
      term: [].sample,
      hits: nil
    )
  end

  it 'request is successful' do
    context = DataHelpers.query(random_active_context)[0]
    response = Search.find_products(
      query: @shared.term,
      store_id: context['store'].to_i,
      metro_id: context['metro'].to_i,
      store_location_id: context['location'].to_i
    )
    expect(response.code).to be 200
    @shared.hits = JSON.parse(response.body)['hits']
  end

  it 'returns relevant results' do
    expect(@shared.hits.find { |p| p['param'].downcase.include? @shared.term }).to be_truthy
  end
end
