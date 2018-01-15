require 'twilio-ruby'

# class that encapsulates IVR
class CallsController < ApplicationController
  skip_before_action :verify_authenticity_token

  FORWARD_CALL = '1'.freeze
  LEAVE_A_MESSAGE = '2'.freeze
  FORWARDING_NUMBER = '+15556667777'.freeze

  # GET / OR /calls
  # Activity feed page
  # JSON api
  def index
    @calls = Call.order('id DESC')

    respond_to do |format|
      format.html
      format.json { render json: @calls }
    end
  end

  # POST /calls
  # Initial entry point for webhook
  def create
    call = Call.create_or_update(params)
    user_selection = params[:Digits]

    response = case user_selection
               when FORWARD_CALL    then forward_call
               when LEAVE_A_MESSAGE then record_voicemail
               else                      main_menu
               end

    render xml: response.to_s
  end

  def main_menu
    response = Twilio::TwiML::VoiceResponse.new
    response.gather(num_digits: 1, timeout: 10) do |gather|
      gather.say("Welcome to Sunny's Interactive Voice Response system.")
      gather.say('Please press 1 to forward the call.')
      gather.say('Please press 2 to leave a message.')
    end

    response.to_s
  end

  # POST /status
  def status_update
    Call.create_or_update(params)
    head :no_content
  end

  # POST /voicemail
  def voicemail_update
    call = Call.find_by!(twilio_call_id: params[:CallSid])
    call.voicemail_url = params[:RecordingUrl]
    call.save!
  end

  def forward_call
    response = Twilio::TwiML::VoiceResponse.new do |r|
      r.say('Forwarding Call.')
      r.dial(number: FORWARDING_NUMBER)
      r.say('Good Bye.')
      r.hangup
    end

    response.to_s
  end

  def record_voicemail
    response = Twilio::TwiML::VoiceResponse.new do |r|
      r.say('Please leave a message after the beep.
             Press the pound key when you are finished.')
      r.record(timeout: 10,
               action: voicemail_complete_path,
               method: 'GET',
               recording_status_callback: voicemail_update_path,
               recording_status_callback_method: 'POST',
               finish_on_key: '#')
      r.say('Your message was not saved.')
      r.hangup
    end

    response.to_s
  end

  # GET /voicemail_complete
  def voicemail_complete
    response = Twilio::TwiML::VoiceResponse.new do |r|
      r.say('Your message has been saved. Good bye.')
      r.hangup
    end

    render xml: response.to_s
  end
end
