class ReservationDetail < ApplicationRecord
  belongs_to :reservation, optional: true
  belongs_to :seat
  belongs_to :price

  validates :seat_id, presence: true
  
end
