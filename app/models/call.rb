class Call < ApplicationRecord
  validates_presence_of :twilio_call_id, :to, :from, :status

  def update_and_save(params)
    self.attributes = {
      twilio_call_id: params[:CallSid],
      from: params[:From],
      to: params[:To],
      status: params[:CallStatus],
      duration: params[:CallDuration],
      direction: params[:Direction]
    }

    self.completed_at = DateTime.current if params[:CallStatus] == 'completed'
    self.save!
  end
end
