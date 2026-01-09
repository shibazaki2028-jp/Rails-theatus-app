class Theater < ApplicationRecord
    has_many :screens, dependent: :destroy
    has_many :schedules, through: :screens

    before_validation :normalize_telephone

    validates :name, presence: true
    validates :address, presence: true
    validates :telephone, presence: true,
        format: { with: /\A\d+\z/, allow_blank: true},
        length: { minimum: 10, maximum: 13, allow_blank: true },
        uniqueness: true

    def formatted_telephone
        return telephone if telephone.blank?
        # ハイフン挿入
        if telephone.length == 10
        telephone.gsub(/(\d{2,3})(\d{3,4})(\d{4})/, '\1-\2-\3')
        else
        telephone.gsub(/(\d{3})(\d{4})(\d{4})/, '\1-\2-\3')
        end
    end
    
    def normalize_telephone
    # ハイフンを除去して保存する
    self.telephone = telephone.gsub(/[-]/, "") if telephone.present?
    end
end
