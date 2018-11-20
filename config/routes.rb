Rails.application.routes.draw do
  devise_for :users,
             controllers: { sessions: 'sessions' },
             defaults: { format: :json },
             skip: :registrations,
             path: 'auth'
  devise_scope :user do
    get 'auth/current', to: 'sessions#show'
    post 'auth/totp', to: 'totp#create'
    post 'auth/send_code', to: 'totp#send_code'
    delete 'auth/totp', to: 'totp#delete'
    resource :registration,
             only: [:create, :update],
             path: 'auth',
             path_names: { new: 'sign_up' },
             controller: 'devise/registrations',
             as: :user_registration,
             defaults: { format: :json }
  end
  # For details on the DSL available within this file, see http://guides.rubyonrails.org/routing.html
end
