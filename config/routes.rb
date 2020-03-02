Rails.application.routes.draw do
  root 'home#index'
  resources :users do
    collection do 
      post :login
      post :logout
      get :widgets
      post :create_widget
      get :show_widget
      get :edit_widget
      get :search_widgets
      post :update_widget
      post :reset_password
    end
  end
end
