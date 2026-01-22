class Account < ApplicationRecord
    has_secure_password

    has_many :reservations, dependent: :destroy
    has_one :administrator, dependent: :destroy
    has_one :theater, through: :administrator, source: :theater, dependent: :destroy

    accepts_nested_attributes_for :administrator

    validates :user_name, presence: true, 
        format: { 
            with: /\A[^0-9]+\z/, 
            message: "に数字を含めることはできません" 
        }
    validates :email, email: { allow_blank: true }, presence: true, uniqueness: { case_sensitive: false}

    attr_accessor :current_password
    validates :password, presence: { if: :current_password }
    validates :role, presence: true

    enum role: { system_admin: 0, theater_admin: 1, general: 2 }
end
