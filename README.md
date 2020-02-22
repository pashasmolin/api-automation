# API Automation

This repo contains a build of test api automation framework in ruby. It uses RestClient to make requests to APIs/services and rspec to test the responses from the requests. It contains just the core of the framework and some sample requests.

## Running locally

- Clone the Repo.
- Navigate to root directory of repo
- `bundle install`
- `rspec #{path_to_spec.rb}`

To generate JUnit results, use
`rspec #{path_to_spec.rb} --format RspecJunitFormatter --out #{results_path.xml}`

## Rubocop setup

- Use the rubocop.yml in the root of the api-automation directory
- To run Rubocop locally `rubocop -c rubocop.yml`
