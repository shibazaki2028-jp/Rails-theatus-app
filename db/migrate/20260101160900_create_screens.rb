class CreateScreens < ActiveRecord::Migration[7.0]
  def change
    create_table :screens do |t|
      t.references :theater, null: false #外部キー
      t.text :info

      t.timestamps
    end
  end
end
