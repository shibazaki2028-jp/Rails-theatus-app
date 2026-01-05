class Reservation < ApplicationRecord
  belongs_to :account
  belongs_to :schedule

  has_many :reservation_details, dependent: :destroy

  validates :account_id, presence: true
  validates :schedule_id, presence: true
end
