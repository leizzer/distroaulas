class AddReccurrentToEventos < ActiveRecord::Migration
  def self.up
    add_column :eventos, :reccurrent, :boolean
  end

  def self.down
    remove_column :eventos, :reccurrent
  end
end
