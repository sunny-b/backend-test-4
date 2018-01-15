Rails.application.routes.draw do
  root to: 'calls#index'

  resources :calls, only: [:index, :create]

  post '/calls/menu', to: 'calls#main_menu', as: :menu
  post 'calls/status_update', as: :status_update
  post 'calls/voicemail_update', as: :voicemail_update
  post 'calls/voicemail_recorded', as: :voicemail_recorded
end
