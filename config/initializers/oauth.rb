
#Rails.application.config.middleware.use OmniAuth::Builder do
  #configure do |config|
    #config.path_prefix = '/myapp/auth' if RAILS_ENV == 'production'
  #end

#  provider  :twitter,
#            TWITTER_CONSUMER_KEY,
#            TWITTER_CONSUMER_SECRET
#end

#require 'oa-oauth'
#use   OmniAuth::Strategies::Twitter,
#      '1pUA29lchvIhz4zPRNpM1w',
#      'fgZHeNlBEXdx8vB65V8CIS03MOROleBe652OpGEI'

Twitter.configure do |config|
  config.consumer_key     = TWITTER_CONSUMER_KEY
  config.consumer_secret  = TWITTER_CONSUMER_SECRET
end