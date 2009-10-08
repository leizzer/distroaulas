class AddCodigoCarreraToMaterias < ActiveRecord::Migration
  def self.up
    add_column :materias, :codigo_carrera, :integer
  end

  def self.down
    remove_column :materias, :codigo_carrera
  end
end
