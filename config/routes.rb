Rails.application.routes.draw do
  devise_for :users, controllers: { omniauth_callbacks: 'users/omniauth_callbacks' }
  # For details on the DSL available within this file, see http://guides.rubyonrails.org/routing.html

  root "home#index"

  get "home/send_mail" => "home#send_mail"

  resources :mpg do
    collection do
      get 'form'
      post 'notify'
      post 'return'
      post 'customer'
    end
  end
end
