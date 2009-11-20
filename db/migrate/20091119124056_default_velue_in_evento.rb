class DefaultVelueInEvento < ActiveRecord::Migration
  def self.up
    change_column :eventos, :exdate, :string, :default => ''
    change_column :eventos, :rdate, :string, :default => ''
  end

  def self.down
    change_column :eventos, :exdate, :string
    change_column :eventos, :rdate, :string
  end
end
