ENV['RACK_ENV'] = 'test'

require File.expand_path('../../app', __FILE__)

require 'pry'
require 'rspec'
require 'rack/test'
require 'webmock/rspec'

RSpec.configure do |config|
  include Rack::Test::Methods
  config.order = 'random'

  def app
    EcrApi::App
  end

  config.expect_with :rspec do |c|
    c.syntax = :expect
  end
end
