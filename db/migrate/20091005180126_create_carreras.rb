class CreateCarreras < ActiveRecord::Migration
  def self.up
    create_table :carreras do |t|
      t.integer :codigo
      t.string :nombre

      t.timestamps
    end
  end

  def self.down
    drop_table :carreras
  end
end
