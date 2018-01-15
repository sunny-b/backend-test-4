Rails.application.routes.draw do
  root to: 'calls#index'
  resources :calls, only: [:index, :create]

  post 'calls/status', to: 'calls#status_update', as: :status_update
  post 'calls/voicemail', to: 'calls#voicemail_update', as: :voicemail_update
  get 'calls/voicemail_complete', as: :voicemail_complete
end
