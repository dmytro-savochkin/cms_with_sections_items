NavigatorClubCms::Application.routes.draw do
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

  #resources :sections, :only => [:index, :show] do
  #  resources :items, :only => [:show]
  #end


  root :to => 'sections#index'





  #match 'admin/sections/*action' => 'admin_sections#sections'
  #match 'admin/items/*action' => 'admin#items'

  namespace :admin do
    resources :sections, :except => ['show']
    resources :items
    resource :session

    match 'login' => 'sessions#new', :as => 'login'
    match 'sections/:id/up' => 'sections#shift', :as => 'section_up', :direction => 'up'
    match 'sections/:id/down' => 'sections#shift', :as => 'section_down', :direction => 'down'
  end

  match 'admin' => 'admin/sections#index'



  match '*section_path' => 'sections#show'
  match '*section_path/item/:item_name' => 'items#show'
end
