class UpdateDescriptionToEventDataFromEventos < ActiveRecord::Migration
  def self.up
    rename_column :eventos, :description, :event_data
  end

  def self.down
    rename_column :eventos, :event_data, :description
  end
end
