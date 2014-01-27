ChattyBackend::Application.routes.draw do

  resources :user, :conversation, :message, :follow, :follower, :my_conversation, :inner_conversation, :get_message, :search_user, :has_friendship, :update_token, :update_user_info
  resources :does_like
  
   match ':controller(/:action(/:id(.:format)))'
end
