class CreateReservationDetails < ActiveRecord::Migration[7.0]
  def change
    create_table :reservation_details do |t|
      t.references :reservation, null: false, foreign_key: true
      t.references :seat, null: false, foreign_key: true

      t.timestamps
    end
  end
end
