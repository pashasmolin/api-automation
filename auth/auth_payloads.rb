# frozen_string_literal: true

require_relative '../common/data_helpers.rb'
require_relative '../common/queries.rb'

#------- Contains all payloads for auth spec -------
class AuthData
  include DataHelpers

  def initialize(username = DataHelpers.query()
    @data = data
  end

  def some_payloads
    {
      'key' => 'value',
      'key' => 'value'
    }
  end
end
