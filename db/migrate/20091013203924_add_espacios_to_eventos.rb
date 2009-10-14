class AddEspaciosToEventos < ActiveRecord::Migration
  def self.up
    add_column :eventos, :espacio_id, :integer
  end

  def self.down
    remove_column :eventos, :espacio_id
  end
end
