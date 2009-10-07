class CreateTipoespacios < ActiveRecord::Migration
  def self.up
    create_table :tipoespacios do |t|
      t.string :nombre
      t.string :descripcion

      t.timestamps
    end
  end

  def self.down
    drop_table :tipoespacios
  end
end
