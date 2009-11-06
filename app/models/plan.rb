class Plan < ActiveRecord::Base
  belongs_to :carrera

  has_many :materias
end
