class Screen < ApplicationRecord
    belongs_to :theater
    has_many :seats, dependent: :destroy
    has_many :schedules, dependent: :destroy

    validates :info, presence: true
  after_create :generate_default_seats

  private

  def generate_default_seats
    ("A".."E").each do |row_name|
      (1..10).each do |num|
        seats.create!(
          queue: row_name,
          verse: num
        )
      end
    end
  end
end
