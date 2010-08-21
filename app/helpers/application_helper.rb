# Methods added to this helper will be available to all templates in the application.
module ApplicationHelper
  # Produces -> Thu 25 Feb 06
  def nice_date(date)
    h date.strftime("%a %d %b %y")
  end
end
