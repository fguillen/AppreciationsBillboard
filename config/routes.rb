Rails.application.routes.draw do
  root :to => "admin/admin_user_sessions#new"

  namespace :admin do
    root :to => redirect("admin/admin_users")

    get "login", :to => "admin_user_sessions#new", :as => :login
    get "logout", :to => "admin_user_sessions#destroy", :as => :logout
    get "forgot_password", :to => "admin_user_sessions#forgot_password", :as => :forgot_password
    post "forgot_password", :to => "admin_user_sessions#forgot_password_submit", :as => :forgot_password_submit
    get "reset_password/:reset_password_code", :to => "admin_users#reset_password", :as => :reset_password
    patch "reset_password/:reset_password_code", :to => "admin_users#reset_password_submit", :as => :reset_password_submit

    resources :admin_user_sessions, :only => [:new, :create, :destroy]
    resources :admin_users
  end

  namespace :api do
    namespace :admin do
      resources :admin_users, :only => [:index, :show, :create, :update, :destroy], :param => :uuid
    end
  end

  get '/auth/:provider/callback' => 'admin/authorizations#create'
  get '/auth/failure' => 'admin/authorizations#failure'
  get '/auth/:provider' => 'admin/authorizations#blank'

  get 'health', :to => "application#health"
end
