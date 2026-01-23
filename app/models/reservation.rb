class Reservation < ApplicationRecord
  belongs_to :account
  belongs_to :schedule

  has_many :reservation_details, dependent: :destroy

  has_many :seats, through: :reservation_details

  validates :account_id, presence: true
  validates :schedule_id, presence: true

  validate :movie_exhibition_period_check

  private
  def movie_exhibition_period_check
    return if schedule.nil? || schedule.movie.nil?
    
      movie = schedule.movie
      screened_date = schedule.screened_at.to_date

      if screened_date > movie.ended_on
        errors.add(:base, "公開期間が終了した映画です")
      end
    end
  end