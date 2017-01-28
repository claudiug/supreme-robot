require 'rubygems'
require 'bundler'

# Set default env
ENV['RACK_ENV'] ||= 'development'

# Setup load paths
Bundler.require
$: << File.expand_path('../', __FILE__)
$: << File.expand_path('../lib', __FILE__)


# Require base
require 'sinatra/base'
require 'active_support'

Dir['lib/**/*.rb'].sort.each { |file| require file }

require 'app/extensions'
require 'app/models'
require 'app/helpers'
require 'app/routes'

module EcrApi
  class App < Sinatra::Application
    configure do
      set :database, lambda {
        ENV['DATABASE_URL'] ||
          "postgres://localhost:5432/ecr_api_#{environment}"
      }
    end

    configure :development, :staging do
      database.loggers << Logger.new(STDOUT)
    end

    configure do
      disable :method_override
      disable :static

      set :sessions,
          httponly: true,
          secure: production?,
          secure: false,
          expire_after: 5.years,
          secret: ENV['SESSION_SECRET']
    end

    Dir['config/initializers/*.rb'].sort.each { |file| require file }

    use Rack::Deflater
    use Rack::Standards
    use Routes::Static

    # Other routes:
    # use Routes::Posts
  end
end

include EcrApi
include EcrApi::Models
