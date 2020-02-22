# frozen_string_literal: true

require_relative './autocomplete_base.rb'

a = Autocomplete.new

describe "Autocomplete Tests" do
  describe "Most popular searches" do
    it "Returns 200" do
      a.response = a.autocomplete_get(a.autocomplete_url + "/suggestions/?params")
      a.response_data = JSON.parse(a.response.body)
      expect(a.response.code).to eq(200)
    end

    it "Schema is correct" do
      expect_correct_schema(a.response.body, a.popular_searches_schema)
    end

    it "Response is not empty" do
      expect(a.response_data['suggestions']).not_to be_empty
    end

    it "Response contains key popular" do
      expect(a.response_data['type']).to eq("popular")
    end
  end

  # availability test in all stores
  a.stores.each do |store|
    describe "Suggestions for word 'Word' in store #{store}" do
      it "Returns non empty result" do
        response = a.autocomplete_get(a.autocomplete_url + "/suggestions/keyword")
        expect(response.code).to eq(200)
        expect(response.hash_body['suggestions']).not_to be_empty
      end
    end
  end

  # tests 100 top search tearms in Store
  a.popular_searches.each_with_index do |word, i|
    search_term = word[0].to_s.gsub(' ', '%20')
    describe "Suggestions for word '#{search_term}', of #{a.popular_searches.length} popular searches in Store" do
      it "Returns non empty result" do
        response = a.autocomplete_get(a.autocomplete_url + "/suggestions/some_params")
        expect(response.code).to eq(200)
        expect(response.hash_body['suggestions']).not_to be_empty
      end
    end
  end
end
