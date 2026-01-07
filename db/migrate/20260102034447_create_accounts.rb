class CreateAccounts < ActiveRecord::Migration[7.0]
  def change
    create_table :accounts do |t|
      t.string :user_name, null: false
      t.string :email, null: false
      t.string :password_digest, null: false
      t.integer :role, null: false

      t.timestamps
    end
  end
end
