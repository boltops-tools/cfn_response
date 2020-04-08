require "bundler/setup"
require "cfn_response"
require "json"

ENV['CFN_RESPONSE_TEST'] = '1'

module Helper
  def event_payload(name)
    JSON.load(IO.read("spec/fixtures/#{name}.json"))
  end

  def null
    double(:null).as_null_object
  end
end

RSpec.configure do |config|
  # Enable flags like --only-failures and --next-failure
  config.example_status_persistence_file_path = ".rspec_status"

  # Disable RSpec exposing methods globally on `Module` and `main`
  config.disable_monkey_patching!

  config.expect_with :rspec do |c|
    c.syntax = :expect
  end

  config.include Helper
end

