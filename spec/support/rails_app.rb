# frozen_string_literal: true

require "rails"
require "active_job"
require "action_controller/railtie"
require "active_support/railtie"

class TestApplication < Rails::Application
  config.logger = Logger.new($stdout)
  config.log_level = :fatal
  config.consider_all_requests_local = true
  config.eager_load = true
end

class HelloJob < ActiveJob::Base
  def perform
    puts "Hello world"
  end
end

class LongJob < ActiveJob::Base
  def perform
    sleep(0.01)
    puts "Hello world"
  end
end

class ErrorJob < ActiveJob::Base
  def perform
    raise StandardError
  end
end

class ErrorLongJob < ActiveJob::Base
  def perform
    sleep(0.01)
    raise StandardError
  end
end

Rails.application = TestApplication

TestApplication.initialize!
