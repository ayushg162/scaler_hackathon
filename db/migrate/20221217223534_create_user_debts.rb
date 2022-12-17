class CreateUserDebts < ActiveRecord::Migration[7.0]
  def change
    create_table :user_debts do |t|
      t.integer :person_with
      t.integer :debt
      t.references :user, foreign_key: true
      t.references :group, foreign_key: true
      t.timestamps
    end
  end
end
