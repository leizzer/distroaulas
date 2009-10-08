class AddCodigoPlanToMaterias < ActiveRecord::Migration
  def self.up
    add_column :materias, :codigo_plan, :integer
  end

  def self.down
    remove_column :materias, :codigo_plan
  end
end
