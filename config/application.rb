require File.expand_path('../boot', __FILE__)

require 'rails/all'

# If you have a Gemfile, require the gems listed there, including any gems
# you've limited to :test, :development, or :production.
Bundler.require(:default, Rails.env) if defined?(Bundler)

module Helpdeck
  class Application < Rails::Application
    # JavaScript files you want as :defaults (application.js is always included).
    config.action_view.javascript_expansions[:defaults] = %w(
      https://ajax.googleapis.com/ajax/libs/jquery/1.4.4/jquery.min.js
      https://ajax.googleapis.com/ajax/libs/jqueryui/1.8.7/jquery-ui.min.js
      rails)

    # Configure the default encoding used in templates for Ruby 1.9.
    config.encoding = "utf-8"

    # Configure sensitive parameters which will be filtered from the log file.
    config.filter_parameters += [:password]
  end
end
