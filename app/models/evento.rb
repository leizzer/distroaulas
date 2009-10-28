class Evento < ActiveRecord::Base
  validates_numericality_of :interval
  before_save :set_dates

  belongs_to :espacio

 def set_dates
   temp = self.dtstart.year.to_s
   if self.dtstart.month.to_s.length == 1
     temp += "0" + self.dtstart.month.to_s
   else
     temp += self.dtstart.month.to_s
   end
   if self.dtstart.day.to_s.length == 1
     temp += "0" + self.dtstart.day.to_s + "T"
   else
     temp += self.dtstart.day.to_s
   end
   if self.dtend.hour.to_s.length == 1
     temp += "0" + self.dtend.hour.to_s 
   else 
     temp += self.dtend.hour.to_s 
   end 
   if self.dtend.min.to_s.length == 1
     temp += "0" + self.dtend.min.to_s
   else
     temp += self.dtend.min.to_s
   end
   self.dtend = DateTime.parse(temp)
 end
end
