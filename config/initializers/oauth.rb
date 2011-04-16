# Setup the OAuth providers here
OAUTH_CONSUMER = {
  :twitter => {
    :key => "1pUA29lchvIhz4zPRNpM1w",
    :secret => "fgZHeNlBEXdx8vB65V8CIS03MOROleBe652OpGEI"
  }
}

# Omniauth config
Rails.application.config.middleware.use OmniAuth::Builder do

  # Twitter provider
  provider  :twitter,
            OAUTH_CONSUMER[:twitter][:key],
            OAUTH_CONSUMER[:twitter][:secret]
          
end

# Twitter Gem Config
Twitter.configure do |config|
  config.consumer_key     = OAUTH_CONSUMER[:twitter][:key]
  config.consumer_secret  = OAUTH_CONSUMER[:twitter][:secret]
end

# APIGEE Config
Twitter.configure do |config|
  config.consumer_key     = OAUTH_CONSUMER[:twitter][:key]
  config.consumer_secret  = OAUTH_CONSUMER[:twitter][:secret]
  config.endpoint         = ENV['APIGEE_TWITTER_API_ENDPOINT']
  config.search_endpoint  = ENV['APIGEE_TWITTER_SEARCH_API_ENDPOINT']
end