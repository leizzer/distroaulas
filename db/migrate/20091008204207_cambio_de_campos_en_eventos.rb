class CambioDeCamposEnEventos < ActiveRecord::Migration
  def self.up
    remove_column :eventos, :event_data
    add_column :eventos, :description, :string
    remove_column :eventos, :exdates
    add_column :eventos, :exdate, :string
  end

  def self.down
    add_column :eventos, :event_data, :string
    remove_column :eventos, :description
    add_column :eventos, :exdates, :string
    remove_column :eventos, :exdate    
  end
end
