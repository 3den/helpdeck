Helpdeck::Application.routes.draw do
  # resources
  resources :q, :controller => :topics, :as => :topics do
    resources :comments, :only => [:create, :destroy]
  end
  # topics
  get   "/q/:id(/a/:comment_id)(.:format)"  => "topics#show", :as => :topic
  get   "/q(.:format)"            => "topics#index", :as => :topics
  get   "/friends/q(.:format)"    => "topics#from_friends", :as => :friends_topics
  get   "/my/q(.:format)"         => "topics#from_me", :as => :my_topics
  get   "/:user/q(.:format)"      => "topics#from", :as => :user_topics

  #votes
  put "/q/:id/vote/:vote"  => "topics#vote", :as => :vote_topic
  put "/a/:id/vote/:vote"  => "comments#vote", :as => :vote_comment

  # users
  match   "/logout" => "session#destroy", :as => :logout
  match   "/auth/:provider/callback" => "session#create", :as => :callback

  # root_url
  root :to => "topics#index"
end