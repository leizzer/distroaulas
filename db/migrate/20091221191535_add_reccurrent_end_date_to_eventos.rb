class AddReccurrentEndDateToEventos < ActiveRecord::Migration
  def self.up
    add_column :eventos, :renddate, :datetime
  end

  def self.down
    remove_column :eventos, :renddate
  end
end
