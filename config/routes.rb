Rails.application.routes.draw do

  get 'home/index'




#<<<<<<< HEAD
  resources :orders, except: :edit do
    member do
      post :new_member
    end
    #resources :items
    resources :items, only: [:create, :destroy]
#=======
  #resources :orders, except: :edit do
  #  resources :items, only: [:create, :destroy]
#>>>>>>> d922137f601ec6520049b8246b81626000fc5806
  end
  resources :groups do
 member do
      post :new_member
     
     # post '/newfollow', to: 'users#newfollow'
    end
 end
 
  # match 'groups/new_member' => 'groups#new_member', :via => :post
  devise_for :users , :controllers => { :omniauth_callbacks => "callbacks" }

  # The priority is based upon order of creation: first created -> highest priority.
  # See how all your routes lay out with "rake routes".


  sockets_for :notifications , only: [:show]
  
  sockets_for :users do
    sockets_for :notifications
  end

  get 'theorders/my_orders(.:format)', to: 'home#getorderbyuser'
  get 'theorders/friends_orders(.:format)', to: 'home#getorderbyfriends'
  get 'finduser/:id/finduser(.:format)', to: 'home#getuser'
  
  get 'allNotifications/:id', to: 'notifications#html_index'
  get 'notifications/:id/clear' , to: 'notifications#see_all_notification_of_me'

  
  # You can have the root of your site routed with "root"
  # root 'welcome#index'

 resources :follows
match 'users/newfollow' => 'users#newfollow', :via => :post
 resources :users do
    member do
      get :follow
      get :unfollow
     # post '/newfollow', to: 'users#newfollow'
    end
 end

  root  'home#index' 

  
  # Example of regular route:
  #   get 'products/:id' => 'catalog#view'
  delete '/orders/:order_id/:user_id', to: 'orders#removeUser', as: 'removeUserfromorder'
  put '/orders/:order_id/:user_id', to: 'orders#joinOrder', as: 'joinuserinorder'
  # Example of named route that can be invoked with purchase_url(id: product.id)
  #   get 'products/:id/purchase' => 'catalog#purchase', as: :purchase

  # Example resource route (maps HTTP verbs to controller actions automatically):
  #   resources :products

  # Example resource route with options:
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

  # Example resource route with sub-resources:
  #   resources :products do
  #     resources :comments, :sales
  #     resource :seller
  #   end

  # Example resource route with more complex sub-resources:
  #   resources :products do
  #     resources :comments
  #     resources :sales do
  #       get 'recent', on: :collection
  #     end
  #   end

  # Example resource route with concerns:
  #   concern :toggleable do
  #     post 'toggle'
  #   end
  #   resources :posts, concerns: :toggleable
  #   resources :photos, concerns: :toggleable

  # Example resource route within a namespace:
  #   namespace :admin do
  #     # Directs /admin/products/* to Admin::ProductsController
  #     # (app/controllers/admin/products_controller.rb)
  #     resources :products
  #   end
end
