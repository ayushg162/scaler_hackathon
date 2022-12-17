class User < ApplicationRecord
    has_many :user_groups
    has_many :transactions
    has_many :user_debts
    has_many :groups, through: :user_groups
end
