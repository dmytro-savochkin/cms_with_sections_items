Maxfoods::Application.routes.draw do
  devise_for :admins

  devise_for :users, :controllers => { :omniauth_callbacks => "client/users/omniauth_callbacks" }
  devise_scope :user do
    get 'sign_in', :to => 'client/users/sessions#new', :as => :new_user_session
    get 'sign_out', :to => 'client/users/sessions#destroy', :as => :destroy_user_session
  end


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


  namespace :admin do
    resources :sections, :except => %w(show)
    resources :items, :except => %w(show)
    resources :comments, :only => %w(destroy index)

    match 'sections/:id/up' => 'sections#shift', :as => 'section_up', :direction => 'up'
    match 'sections/:id/down' => 'sections#shift', :as => 'section_down', :direction => 'down'

    match 'items/:id/up' => 'items#shift', :as => 'item_up', :direction => 'up'
    match 'items/:id/down' => 'items#shift', :as => 'item_down', :direction => 'down'
  end
  match 'admin' => 'admin/sections#index'



  scope :module => "client" do
    root :to => 'sections#index'
    match '*section_path/item/:item_name' => 'items#show'
    match '*section_path' => 'sections#show'
  end
end
