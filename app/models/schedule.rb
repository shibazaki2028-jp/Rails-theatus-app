class Schedule < ApplicationRecord
    belongs_to :movie
    belongs_to :screen

    has_many :reservations, dependent: :destroy

    validates :movie_id, presence: true
    validates :screen_id, presence: true
    validates :screened_at, presence: true
    validates :ended_at, presence: true

    validate :schedule_overlap

    before_validation :set_ended_at

    #上映終了時間は開始時刻から映画の上映時間プラス20分で計算して設定する
    def set_ended_at
        if screened_at.present? && movie.present?
            self.ended_at = screened_at + (movie.screening_time + 20).minutes
        end
    end

    def schedule_overlap
        overlap = Schedule
            .where(screen_id: screen_id)
            .where.not(id: id)
            .where("screened_at < ? AND ended_at > ? ", ended_at, screened_at)
            .exists?
        
        if overlap
            errors.add(:screened_at, "が他の上映時間と重複しています")
        end
    end

end
