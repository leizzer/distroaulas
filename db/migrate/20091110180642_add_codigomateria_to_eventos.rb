class AddCodigomateriaToEventos < ActiveRecord::Migration
  def self.up
    add_column :eventos, :materia_id, :integer
  end

  def self.down
    remove_column :eventos, :materia_id
  end
end
