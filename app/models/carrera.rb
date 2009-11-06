class Carrera < ActiveRecord::Base
  has_many :plans

  has_many :materias
end
