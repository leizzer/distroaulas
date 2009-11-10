class AddCodigomateriaToEventos < ActiveRecord::Migration
  def self.up
    add_column :eventos, :codigo_materia, :integer
  end

  def self.down
    remove_column :eventos, :codigo_materia
  end
end
