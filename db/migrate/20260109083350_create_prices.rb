class CreatePrices < ActiveRecord::Migration[7.0]
  def change
    create_table :prices do |t|
      t.integer :ticket_type, null: false #券種
      t.integer :price, null: false #金額
      t.timestamps
    end
  end
end