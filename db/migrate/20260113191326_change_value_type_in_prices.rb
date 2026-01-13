class ChangeValueTypeInPrices < ActiveRecord::Migration[7.0]
  def change
    change_column :prices, :ticket_type, :string
  end
end
