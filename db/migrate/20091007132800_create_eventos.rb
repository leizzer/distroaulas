class CreateEventos < ActiveRecord::Migration
  def self.up
    create_table :eventos do |t|
      t.string :description
      t.string :dtstart
      t.string :dtend
      t.string :freq
      t.string :bydate
      t.string :interval

      t.timestamps
    end
  end

  def self.down
    drop_table :eventos
  end
end
