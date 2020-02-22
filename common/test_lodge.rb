# frozen_string_literal: true

require 'httparty'

class TestLodge
  include HTTParty

  base_uri 'url'

  def initialize
    # credentials need to be set up in users' bash profiles
    @auth = { username: (ENV['Test_Lodge_UN']).to_s, password: (ENV['Test_Lodge_PW']).to_s }
    @test_lodge_suite = ENV['TEST_LODGE_SUITE'].to_i
  end

  # gets a list of available test runs in test lodge for the mobile apps project
  def get_runs(options = {})
    options[:basic_auth] = @auth
    self.class.get("/projects/id/runs.json", options)
  end

  # gets a list of available test runs in test lodge for the mobile apps project
  def get_test_suite(page, options = {})
    options[:basic_auth] = @auth
    options[:body] = {
      page: page
    }
    self.class.get("/projects/id/suites/#{@test_lodge_suite}/steps.json", options)
  end

  # creates a new test run in test lodge
  def new_run(name, options = {})
    options[:basic_auth] = @auth
    options[:body] = {
      run: {
        name: name.to_s,
        suite_ids: [@test_lodge_suite] 
      }
    }
    puts options.to_s
    self.class.post('/projects/id/runs.json', options)
  end

  def get_run_cases(run_id, options = {})
    options[:basic_auth] = @auth
    self.class.get("/projects/id/runs/#{run_id}/executed_steps.json", options)
  end

  # sends the result (0 for fail, 1 for pass) to test lodge for the associated test run (run_id) and test case (case_id)
  def test_result(run_id, case_id, result, error_message = '', options = {})
    unless !error_message.nil?
      error_message = 'PASSED'
    end
    options[:basic_auth] = @auth
    options[:body] = {
      executed_step: {
        actual_result:  error_message,
        passed: result
      }
    }
    self.class.patch("/projects/id/runs/#{run_id}/executed_steps/#{case_id}.json", options)
  end

  def find_test_case_id(test_case, cases)
    cases[cases.find_index { |elem| elem["step_number"] == test_case }]["id"].to_s
  end
end
