class Evento < ActiveRecord::Base
  validates_numericality_of :interval
end
