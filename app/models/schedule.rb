class Schedule < ApplicationRecord
    belongs_to :movie
    belongs_to :screen

    validates :movie_id, presence: true
    validates :screen_id, presence: true
    validates :screened_at, presence: true
    validates :ended_at, presence: true

    before_validation :set_ended_at

    #上映終了時間は開始時刻から映画の上映時間プラス20分で計算して設定する
    def set_ended_at
        if screened_at.present? && movie.present?
            self.ended_at = screened_at + (movie.screening_time + 20).minutes
        end
    end
end
