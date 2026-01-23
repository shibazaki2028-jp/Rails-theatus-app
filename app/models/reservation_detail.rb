class ReservationDetail < ApplicationRecord
  belongs_to :reservation, optional: true
  belongs_to :seat
  belongs_to :price

  validates :seat_id, presence: true
  validate :seat_availability_check

  private
  def seat_availability_check
    if ReservationDetail.joins(:reservation)
                        .where(reservations: { schedule_id: reservation.schedule_id })
                        .where(seat_id: seat_id)
                        .exists?
      errors.add(:seat_id, "は既に予約されています")
    end
  end
end
