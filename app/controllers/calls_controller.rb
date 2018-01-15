require 'twilio-ruby'

# class that encapsulates IVR
class CallsController < ApplicationController
  skip_before_action :verify_authenticity_token

  FORWARD_CALL = '1'.freeze
  LEAVE_A_MESSAGE = '2'.freeze
  FORWARDING_NUMBER = '+12017900279'.freeze

  # GET /
  # Activity feed page
  # JSON api
  def index
    @calls = Call.all

    respond_to do |format|
      format.html
      format.json { render json: @calls }
    end
  end

  # POST /calls
  # Create call entry in database
  def create
    call = Call.new
    call.update_and_save(params)
    user_selection = params[:Digits]

    case user_selection
    when FORWARD_CALL    then forward_call
    when LEAVE_A_MESSAGE then record_voicemail
    else                      main_menu(false)
    end
  end

  # POST /calls/menu
  # Initial start point for Twilio webhook
  def main_menu(first_time = true)
    response = Twilio::TwiML::VoiceResponse.new
    response.gather(num_digits: 1, action: '/calls', method: 'POST') do |gather|
      if first_time
        gather.say("Welcome to Sunny's Interactive Voice Response system.")
      end

      gather.say('Please press 1 to forward the call.')
      gather.say('Please press 2 to leave a message.')
    end

    render xml: response.to_s
  end

  def status_update
    call = Call.find_by!(twilio_call_id: params[:CallSid])
    call.update_and_save(params)

    head :no_content
  end

  def voicemail_update
    call = Call.find_by!(twilio_call_id: params[:CallSid])
    call.voicemail_url = params[:RecordingUrl]
    call.save!

    head :no_content
  end

  def forward_call
    response = Twilio::TwiML::VoiceResponse.new do |r|
      r.say('Forwarding Call.')
      r.dial(number: FORWARDING_NUMBER,
             status_callback: status_update_path,
             status_callback_method: 'POST')
      r.say('Good Bye.')
      r.hangup
    end

    render xml: response.to_s
  end

  def record_voicemail
    response = Twilio::TwiML::VoiceResponse.new do |r|
      r.say('Please leave a message at the beep.
             Press the pound key when finished.')
      r.record(timeout: 10,
               action: voicemail_recorded_path,
               recording_status_callback: voicemail_update_path,
               recording_status_callback_method: 'POST',
               finish_on_key: '#')
      r.say('Your message was not saved.')
      r.hangup
    end

    render xml: response.to_s
  end

  def voicemail_recorded
    response = Twilio::TwiML::VoiceResponse.new do |r|
      r.say('Your message has been saved.')
      r.hangup
    end

    render xml: response.to_s
  end
end
