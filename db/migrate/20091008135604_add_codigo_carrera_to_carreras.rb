class AddCodigoCarreraToCarreras < ActiveRecord::Migration
  def self.up
    add_column :carreras, :codigo_carrera, :integer
  end

  def self.down
    remove_column :carreras, :codigo_carrera
  end
end
