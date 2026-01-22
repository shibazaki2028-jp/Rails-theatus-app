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

  validate :date_check

  private

  def date_check
    return if published_on.blank? || ended_on.blank?

    if ended_on < published_on
      errors.add(:ended_on, "は公開開始日以降の日付を選択してください")
    elsif ended_on < Date.today
      errors.add(:ended_on, "は今日以降の日付を選択してください")
    end
  end

  enum :category, { "ホラー": "1", "アクション": "2", "コメディ": "3", "フィクション": "4", "恋愛": "5",  "SF": "6" }

  class << self
    def search(title, category, address, publish)
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
        if publish.present?
            rel = rel.where(publish: publish)
        end
        rel
    end
  end
end
