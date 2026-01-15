class Administrator < ApplicationRecord
  belongs_to :account
  belongs_to :theater
end
