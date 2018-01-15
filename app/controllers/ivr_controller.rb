require 'twilio-ruby'

class IvrController < ApplicationController
  skip_before_action :verify_authenticity_token

  FORWARD_CALL = '1'
  LEAVE_A_MESSAGE = '2'
  FORWARDING_NUMBER = '+12017900279'

  def main_menu(first_time = true)
    response = Twilio::TwiML::VoiceResponse.new
    response.gather(num_digits: 2, action: menu_selection_path) do |gather|
      if first_time
        gather.say("Welcome to Sunny's Interactive Voice Response system.")
      end

      gather.say('Please press 1 to forward the call.')
      gather.say('Please press 2 to leave a message.')
    end

    render xml: response.to_s
  end

  def menu_selection
    user_selection = params[:Digits]

    case user_selection
    when FORWARD_CALL    then forward_call
    when LEAVE_A_MESSAGE then record_voicemail
    else                      main_menu(false)
    end
  end

  def voicemail; end

  def forward_call
    response = Twilio::TwiML::VoiceResponse.new do |r|
      r.say('Forwarding Call.')
      r.dial(number: FORWARDING_NUMBER)
    end

    render xml: response.to_s
  end

  def record_voicemail
    response = Twilio::TwiML::VoiceResponse.new do |r|
      r.say('Please leave your message after the beep.')
      r.record(timeout: 10, action: voicemail_path)
    end

    render xml: response.to_s
  end
end
