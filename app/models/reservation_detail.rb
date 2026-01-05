class ReservationDetail < ApplicationRecord
  belongs_to :reservation
  belongs_to :seat

  validates :reservation_id, presence: true
  validates :seat_id, presence: true
  
end
