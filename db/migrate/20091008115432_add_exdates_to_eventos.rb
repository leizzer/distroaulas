class AddExdatesToEventos < ActiveRecord::Migration
  def self.up
    add_column :eventos, :exdates, :string
  end

  def self.down
    remove_column :eventos, :exdates
  end
end
