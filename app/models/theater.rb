class Theater < ApplicationRecord
    has_many :screens, dependent: :destroy

    validates :name, presence: true
    validates :address, presence: true
    validates :telephone, presence: true,
        format: { with: /\A\d+\z/, allow_blank: true},
        length: { minimum: 9, maximum: 13, allow_blank: true },
        uniqueness: true
end
