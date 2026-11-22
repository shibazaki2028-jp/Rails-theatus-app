class ReservationDetail < ApplicationRecord
  belongs_to :reservation
  belongs_to :seat
  belongs_to :price

  validates :seat_id, presence: true
  validate :seat_availability_check

  before_validation :copy_schedule_id_from_reservation

  private
  def seat_availability_check
    if ReservationDetail.where(schedule_id: schedule_id)
                        .where(seat_id: seat_id)
                        .where.not(id: id)
                        .exists?
      errors.add(:seat_id, "は既に予約されています")
    end
  end

  def copy_schedule_id_from_reservation
    self.schedule_id = reservation.schedule_id if reservation.present?
  end
end
