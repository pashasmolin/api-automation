# frozen_string_literal: true

require 'json'
require 'pg'

module DataHelpers
  def self.file_to_json(file_path)
    JSON.parse(File.read(file_path))
  end

  def self.query(query)
    conn = PG::Connection.new("url", 5432, "", "", "dbname", ENV['USERNAME'], ENV['PASSWORD'])
    result = conn.exec(query)
    conn.close
    result
  ensure
    conn.close if !conn.finished?
  end
end
