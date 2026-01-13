class AddPriceToReservationDetails < ActiveRecord::Migration[7.0]
  def change
    add_reference :reservation_details, :price, null: false, foreign_key: true
  end
end
