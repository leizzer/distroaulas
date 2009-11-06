class Materia < ActiveRecord::Base
  belongs_to :plan

  belongs_to :carrera
end
