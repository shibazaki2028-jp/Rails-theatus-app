class Reservation < ApplicationRecord
  belongs_to :account
  belongs_to :schedule

  has_many :reservation_details, dependent: :destroy

  has_many :seats, through: :reservation_details

  validates :account_id, presence: true
  validates :schedule_id, presence: true
end
