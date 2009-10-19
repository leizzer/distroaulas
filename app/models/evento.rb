class Evento < ActiveRecord::Base
  validates_numericality_of :interval
  before_save :end_date_set

  belongs_to :espacio

 def end_date_set
   temp = self.dtstart.year.to_s
   if self.dtstart.month.to_s.length == 1
     temp += "0" + self.dtstart.month.to_s
   else
     temp += self.dtstart.month.to_s
   end
   if self.dtstart.day.to_s.length == 1
     temp += "0" + self.dtstart.day.to_s + "T"
   else
     temp += self.dtstart.day.to_s + "T"
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
   debugger
   
   self.dtend = DateTime.parse(temp)
 end
end
