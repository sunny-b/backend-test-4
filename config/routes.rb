Rails.application.routes.draw do
  post '/ivr', to: 'ivr#main_menu', as: :menu
  post '/ivr/menu_selection', as: :menu_selection
  post '/ivr/voicemail', as: :voicemail
end
