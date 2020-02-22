# frozen_string_literal: true

require 'json'
require_relative './data_helpers.rb'

CONFIG = DataHelpers.file_to_json(ENV['CONFIG_FILE'].nil? ? 'common/config.json' : ENV['CONFIG_FILE'])
CONFIG.each { |key, value| CONFIG[key] = ENV[key] ||= value }
