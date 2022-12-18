class User < ApplicationRecord
    has_many :user_groups
    has_many :transactions
    has_many :user_debts
    has_many :person_user_debts, class_name: 'UserDebt', foreign_key: 'person_id'
    has_many :person_with_user_debts, class_name: 'UserDebt', foreign_key: 'person_with_id'
    has_many :groups, through: :user_groups
end
