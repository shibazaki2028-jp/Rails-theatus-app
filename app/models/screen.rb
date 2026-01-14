class Screen < ApplicationRecord
    belongs_to :theater
    has_many :seats, dependent: :destroy
    has_many :schedules, dependent: :destroy

    validates :info, presence: true
  after_create :generate_default_seats

  def theater_and_screen_name
    "#{theater.name} - #{info} (ID: #{id})"
  end

  private

  def generate_default_seats
    Seat.generate_for(self)
  end
end
