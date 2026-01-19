class Movie < ApplicationRecord
  has_many :schedules
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

  enum :category, { "アクション": "1", "コメディ": "2", "フィクション": "3", "恋愛": "4", "ホラー": "5", "SF": "6" }

  class << self
    def search(title, category, address)
        rel = all
        if title.present?
            rel = rel.where("title LIKE ? ", "%#{title}%")
        end
        if category.present?
            rel = rel.where(category: category)
        end
        if address.present?
            rel = rel.joins(schedules: :theater)
            .where("theaters.address LIKE ?", "%#{address}%")
            .distinct
        end
        rel
    end
  end
end
