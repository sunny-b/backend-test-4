require 'twilio-ruby'

class CallsController < ApplicationController
  skip_before_action :verify_authenticity_token

  def main_menu
    response = Twilio::TwiML::VoiceResponse.new
    response.gather(num_digits: 2, action: menu_selection_path) do |gather|
      gather.say("Welcome to Sunny's Interactive Voice Response system.")
      gather.say('Please press 1 to forward the call.')
      gather.say('Please press 2 to leave a message.')
    end

    render xml: response.to_s
  end

  def menu_selection; end
end
