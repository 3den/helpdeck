# Setup the OAuth providers here
OAUTH_PROVIDERS = {
  :twitter => {
    :key => "1pUA29lchvIhz4zPRNpM1w",
    :secret => "fgZHeNlBEXdx8vB65V8CIS03MOROleBe652OpGEI"
  }
}

# Omniauth config
Rails.application.config.middleware.use OmniAuth::Builder do

  # Twitter provider
  provider  :twitter,
            OAUTH_PROVIDERS[:twitter][:key],
            OAUTH_PROVIDERS[:twitter][:secret]
          
end

# This is for APIGEE
#Twitter.configure do |config|
#  config.consumer_key     = TWITTER_CONSUMER_KEY
#  config.consumer_secret  = TWITTER_CONSUMER_SECRET
#  config.endpoint         = ENV['APIGEE_TWITTER_API_ENDPOINT']
#  config.search_endpoint  = ENV['APIGEE_TWITTER_SEARCH_API_ENDPOINT']
#end