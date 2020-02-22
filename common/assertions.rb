# frozen_string_literal: true

require 'rspec'
require 'json_schema'

module ExpectHelpers
  def expect_correct_schema(response, schema)
    schema_checker = JsonSchema.parse!(schema)
    schema_checker.validate!(JSON.parse(response))
  end

  def expect_array_value(array)
    expect(array.length).to be_positive
  end
end
