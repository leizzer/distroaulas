class CreateEspacios < ActiveRecord::Migration
  def self.up
    create_table :espacios do |t|
      t.string :codigo
      t.string :descripcion
      t.string :capacidad
      t.string :tipo

      t.timestamps
    end
  end

  def self.down
    drop_table :espacios
  end
end
