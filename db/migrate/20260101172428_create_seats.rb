class CreateSeats < ActiveRecord::Migration[7.0]
  def change
    create_table :seats do |t|
      t.references :screen, null: false, foreigne_key: true
      t.string :verse, null: false
      t.string :queue, null: false


      t.timestamps
    end
  end
end
