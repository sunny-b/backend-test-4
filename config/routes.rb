Rails.application.routes.draw do
  resources :calls, only: [:index, :create]

  post '/calls/menu', to: 'calls#main_menu', as: :menu
  post '/calls/voicemail', as: :voicemail
end
