class Espacio < ActiveRecord::Base
  belongs_to :tipoespacio

  has_many :eventos
end
