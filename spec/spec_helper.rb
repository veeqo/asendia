require "bundler/setup"
require 'webmock/rspec'
require 'byebug'
require "asendia"

RSpec.configure do |config|
  # Enable flags like --only-failures and --next-failure
  config.example_status_persistence_file_path = ".rspec_status"

  # Disable RSpec exposing methods globally on `Module` and `main`
  config.disable_monkey_patching!

  config.expect_with :rspec do |c|
    c.syntax = :expect
  end
end

require 'vcr'

VCR.configure do |config|
  config.cassette_library_dir = "#{Dir.pwd}/spec/vcr_cassettes/asendia"
  config.configure_rspec_metadata!
  config.hook_into :webmock
end
