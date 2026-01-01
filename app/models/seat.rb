class Seat < ApplicationRecord
    belongs_to :screen

    validates :verse, presence: true
    validates :queue, presence: true,
        uniqueness: true
end
