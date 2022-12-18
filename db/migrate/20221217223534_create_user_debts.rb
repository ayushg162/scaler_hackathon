class CreateUserDebts < ActiveRecord::Migration[7.0]
  def change
    create_table :user_debts do |t|
      # t.references :person_with, foreign_key: true
      t.integer :debt
      t.references :person_with, null: false
      t.references :person, null: false
      t.references :group, foreign_key: true
      t.timestamps
    end
    add_foreign_key :user_debts, :users, column: :person_with_id
    add_foreign_key :user_debts, :users, column: :person_id
    # add_foreign_key :user_debts, :groups, column: :group_id
  end
end
