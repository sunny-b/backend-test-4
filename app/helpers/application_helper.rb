module ApplicationHelper
  def display_datetime(dt)
    dt.strftime("%m/%d/%y %I:%M%p")
  end
end
