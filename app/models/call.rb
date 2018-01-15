class Call < ApplicationRecord
  validates_presence_of :twilio_call_id, :to, :from, :status

  def self.create_or_update(params)
    call = Call.find_or_initialize_by(twilio_call_id: params[:CallSid])

    call.attributes = {
      twilio_call_id: params[:CallSid],
      from: params[:From],
      to: params[:To],
      status: params[:CallStatus],
      duration: params[:CallDuration],
      direction: params[:Direction]
    }

    call.completed_at = DateTime.current if params[:CallStatus] == 'completed'
    call.save!
    call
  end
end
