class AddAnioToMateria < ActiveRecord::Migration
  def self.up
    add_column :materias, :anio, :integer
  end

  def self.down
    remove_column :materias, :anio
  end
end
