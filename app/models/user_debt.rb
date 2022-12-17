class UserDebt < ApplicationRecord
    belongs_to :user
    belongs_to :user_debts
end
