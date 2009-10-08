class CorrectEventosColumnsByday < ActiveRecord::Migration
  def self.up
    rename_column :eventos, :bydate, :byday
  end

  def self.down
    rename_column :eventos, :byday, :bydate
  end
end
