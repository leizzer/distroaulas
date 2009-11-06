class AddTipoToUsers < ActiveRecord::Migration
  def self.up
    add_column :users, :tipo, :string
  end

  def self.down
    remove_column :users, :tipo
  end
end
