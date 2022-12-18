class UserDebt < ApplicationRecord
    belongs_to :person, class_name: 'User'
    belongs_to :person_with, class_name: 'User'
    # belongs_to :group
    has_many :users
end
