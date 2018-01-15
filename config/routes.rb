Rails.application.routes.draw do
  post '/calls/menu', to: 'calls#main_menu', as: :menu
  post '/calls/menu_selection', as: :menu_selection
  post '/calls/voicemail', as: :voicemail
end
