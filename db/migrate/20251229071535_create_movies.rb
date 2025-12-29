class CreateMovies < ActiveRecord::Migration[7.0]
  def change
    create_table :movies do |t|
      t.string :title, null: false #映画名
      t.string :category, null: false #映画のジャンル・カテゴリ
      t.text :body, null: false #映画の説明
      t.boolean :publish, null: false #公開・非公開
      t.date :published_on, null: false #上映開始日
      t.date :ended_on, null: false #上映終了日
      t.integer :screening_time, null: false #上映時間

      t.timestamps null: false
    end
  end
end
