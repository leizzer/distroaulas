# WeeklyCalendar by Dan McGrady 2009
module WeeklyCalendar
  
  def weekly_calendar(objects, *args)
    #view helper to build the weekly calendar
    options = args.last.is_a?(Hash) ? args.pop : {}
    date = options[:date] || Time.now
    start_date = Date.new(date.year, date.month, date.day)
    end_date = Date.new(date.year, date.month, date.day) # + 6 #Max days to show on the render
    title = options[:title] || "Eventos"
    
    concat(tag("div", :id => "week"))
  
      yield WeeklyCalendar::Builder.new(objects || [], self, options, start_date, end_date, title)
      
    concat("</div>")
    
    if options[:include_24_hours] == true
      concat("<b><a href='?business_hours=true&start_date=#{start_date}'>Turno Tarde</a> | <a href='?business_hours=false&start_date=#{start_date}'>24 horas</a></b>") # start_date=#{start_date}
    end
  end
  
  def weekly_links(options)
    #view helper to insert the next and previous week links
    date = options[:date] || Time.now
    start_date = Date.new(date.year, date.month, date.day) 
    end_date = Date.new(date.year, date.month, date.day) + 7
    concat("<a href='?start_date=#{start_date - 7}?user_id='>« Previous Week</a> ")
    concat("#{start_date.strftime("%B %d -")} #{end_date.strftime("%B %d")} #{start_date.year}")
    concat(" <a href='?start_date=#{start_date + 7}?user_id='>Next Week »</a>")
  end

end
