class Account < ApplicationRecord
    has_secure_password

    has_many :reservations
    #has_many :administrators

    validates :user_name, presence: true
    validates :email, email: { allow_blank: true }

    attr_accessor :current_password
    validates :password, presence: { if: :current_password }
    validates :role, presence: true

    enum role: { system_admin: 0, theater_admin: 1, general: 2 }
end
