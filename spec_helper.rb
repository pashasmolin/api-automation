# frozen_string_literal: true

require 'allure-rspec'
require 'pathname'
require './common/config.rb'
require './common/assertions.rb'
require './common/test_lodge.rb'
require 'socket'

logs_folder_path = './logs'
debug_log_file_path = './logs/debug_log.txt'
tl = TestLodge.new
run_id = nil

RSpec.configure do |config|
  config.include AllureRSpec::Adaptor
  config.include ExpectHelpers
  unless ENV['TEST_LODGE_SUITE'].nil? # checks for TEST_LODGE_SUITE string to be valid by checking for length
    config.before(:suite) do
      run_id = tl.new_run("#{ENV['TEST_NAME']} Automated Run")["id"]
    end
  end

  config.before(:each) do
    Dir.mkdir(logs_folder_path) unless Dir.exist?(logs_folder_path)
    File.open(debug_log_file_path, 'w')
  end

  config.after(:each) do |e|
    if (e.description.partition(':').first.include? "param") && !ENV['SUITE'].nil? # checks for TEST_LODGE_SUITE string to be valid by checking for length
      cases = tl.get_run_cases(run_id)["executed_steps"]
      run_case = tl.find_test_case_id(e.description.partition(':').first, cases)
    end
    e.attach_file 'debug_log.txt', File.open(debug_log_file_path) unless File.zero?(debug_log_file_path)
    if !e.exception.nil?
      tl.test_result(run_id, run_case, 0, e.exception) unless run_case.nil?
      ENV['TEST_FAILS'] = (ENV['TEST_FAILS'].to_i + 1).to_s
    else
      tl.test_result(run_id, run_case, 1, e.exception) unless run_case.nil?
      ENV['TEST_PASS'] = (ENV['TEST_PASS'].to_i + 1).to_s
    end
    ENV['TEST_TOTAL'] = (ENV['TEST_TOTAL'].to_i + 1).to_s
  end
end

at_exit do
  api_key = ENV['GRAPHITE_API']
  unless ENV['TEST_NAME'].nil?
    body = "QA.#{ENV['TEST_NAME']}.Tests.TOTAL_TESTS #{ENV['TEST_TOTAL']}\n"
    conn = TCPSocket.new 'url', 2003
    conn.puts "#{api_key}.#{body}"
    fail_body = if !ENV['TEST_FAILS'].nil?
                  "QA.#{ENV['TEST_NAME']}.Tests.FAIL #{ENV['TEST_FAILS']}\n"
                else
                  "QA.#{ENV['TEST_NAME']}.Tests.FAIL 0\n"
                end
    conn.puts "#{api_key}.#{fail_body}"
    conn.close
  end
end
