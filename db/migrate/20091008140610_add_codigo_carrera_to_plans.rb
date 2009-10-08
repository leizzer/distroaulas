class AddCodigoCarreraToPlans < ActiveRecord::Migration
  def self.up
    add_column :plans, :codigo_carrera, :integer
  end

  def self.down
    remove_column :plans, :codigo_carrera
  end
end
