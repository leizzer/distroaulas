class RemoveCodigoCarreraFromCarreras < ActiveRecord::Migration
  def self.up
    remove_column :carreras, :codigo_carrera
  end

  def self.down
    add_column :carreras, :codigo_carrera, :integer
  end
end
