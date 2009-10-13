class Evento < ActiveRecord::Base
  validates_numericality_of :interval

  belongs_to :espacio
end
