class RemoveTipoFromEspaciosAndAddTipoespaciosIdToEspacios < ActiveRecord::Migration
  def self.up
    remove_column :espacios, :tipo
    add_column :espacios, :tipoespacio_id, :integer
  end

  def self.down
    remove_column :espacios, :tipoespacio_id
    add_column :espacios, :tipo
  end
end
