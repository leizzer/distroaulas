class CreateMaterias < ActiveRecord::Migration
  def self.up
    create_table :materias do |t|
      t.integer :codigo
      t.string :nombre

      t.timestamps
    end
  end

  def self.down
    drop_table :materias
  end
end
