Helpdeck::Application.routes.draw do

  # resources
  resources :topics, :only => [:create, :destroy, :update, :new, :edit] do
    resources :comments, :only => [:create, :destroy]
  end
  # topics
  get   "/q/:id(/a/:comment_id)(.:format)"  => "topics#show", :as => :topic
  get   "/friends/q(.:format)"    => "topics#from_friends", :as => :friends_topics
  get   "/my/q(.:format)"         => "topics#from_me", :as => :my_topics
  get   "/:user/q(.:format)"      => "topics#from", :as => :user_topics
  
  #votes
  put "/q/:id/vote/:vote"  => "topics#vote", :as => :vote_topic
  put "/a/:id/vote/:vote"  => "comments#vote", :as => :vote_comment

  # users
  match   "/auth/:provider" => "session#new", :as => :login
  match   "/logout" => "session#destroy", :as => :logout
  match   "/auth/:provider/callback" => "session#create", :as => :callback

  # root_url
  root :to => "topics#index"
  
  # The priority is based upon order of creation:
  # first created -> highest priority.

  # Sample of regular route:
  #   match 'products/:id' => 'catalog#view'
  # Keep in mind you can assign values other than :controller and :action

  # Sample of named route:
  #   match 'products/:id/purchase' => 'catalog#purchase', :as => :purchase
  # This route can be invoked with purchase_url(:id => product.id)

  # Sample resource route (maps HTTP verbs to controller actions automatically):
  #   resources :products

  # Sample resource route with options:
  #   resources :products do
  #     member do
  #       get 'short'
  #       post 'toggle'
  #     end
  #
  #     collection do
  #       get 'sold'
  #     end
  #   end

  # Sample resource route with sub-resources:
  #   resources :products do
  #     resources :comments, :sales
  #     resource :seller
  #   end

  # Sample resource route with more complex sub-resources
  #   resources :products do
  #     resources :comments
  #     resources :sales do
  #       get 'recent', :on => :collection
  #     end
  #   end

  # Sample resource route within a namespace:
  #   namespace :admin do
  #     # Directs /admin/products/* to Admin::ProductsController
  #     # (app/controllers/admin/products_controller.rb)
  #     resources :products
  #   end

  # You can have the root of your site routed with "root"
  # just remember to delete public/index.html.
  # root :to => "welcome#index"

  # See how all your routes lay out with "rake routes"

  # This is a legacy wild controller route that's not recommended for RESTful applications.
  # Note: This route will make all actions in every controller accessible via GET requests.
  # match ':controller(/:action(/:id(.:format)))'
end
