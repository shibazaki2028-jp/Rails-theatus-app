class CreateSchedules < ActiveRecord::Migration[7.0]
  def change
    create_table :schedules do |t|
      #外部キーとの関連付け
      t.references :movie, null: false, foreign_key: true
      t.references :screen, null: false, foreign_key: true

      t.datetime :screened_at , null: false#上映開始時刻
      t.datetime :ended_at #上映終了時刻

      t.timestamps null: false
    end
  end
end
