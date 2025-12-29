class Movie < ApplicationRecord
  validates :title, presence: true
  validates :category, presence: true
  validates :published_on, presence: true
  validates :ended_on, presence: true

  #上映時間は0より大きい数値でなければいけない
  validates :screening_time, presence: true,
  numericality: {
      only_integer: true,
      greater_than: 0,
      allow_blank: true
  }

  validates :publish, inclusion: { in: [true, false] }
end
