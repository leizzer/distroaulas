class AddRdateToEventos < ActiveRecord::Migration
  def self.up
    add_column :eventos, :rdate, :string
  end

  def self.down
    remove_column :eventos, :rdate
  end
end
