class AddScheduleIdToReservationDetails < ActiveRecord::Migration[7.0]
  def up
    # 1. NULL許可でカラム追加＋外部キー（単独インデックスは複合ユニークと重複するので付けない）
    add_reference :reservation_details, :schedule, foreign_key: true, index: false

    # 2. 親の予約から schedule_id を書き写す
    execute <<~SQL
      UPDATE reservation_details
      SET schedule_id = (
        SELECT reservations.schedule_id
        FROM reservations
        WHERE reservations.id = reservation_details.reservation_id
      )
    SQL

    null_count = select_value(<<~SQL).to_i
      SELECT COUNT(*) FROM reservation_details WHERE schedule_id IS NULL
    SQL
    raise "schedule_id が埋まっていない明細が #{null_count} 件あります" if null_count > 0

    # 3. (schedule_id, seat_id) の組で重複がないか確認
    duplicate_count = select_value(<<~SQL).to_i
      SELECT COUNT(*) FROM (
        SELECT schedule_id, seat_id
        FROM reservation_details
        GROUP BY schedule_id, seat_id
        HAVING COUNT(*) > 1
      )
    SQL
    raise "同じ上映回・座席の明細が #{duplicate_count} 組重複しています" if duplicate_count > 0

    # 4. NOT NULL にする
    change_column_null :reservation_details, :schedule_id, false

    # 5. 同じ上映回・同じ座席は1件まで
    add_index :reservation_details, [:schedule_id, :seat_id], unique: true
  end

  def down
    remove_index :reservation_details, column: [:schedule_id, :seat_id]
    remove_reference :reservation_details, :schedule, foreign_key: true, index: false
  end
end