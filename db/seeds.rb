# This file should contain all the record creation needed to seed the database with its default values.
# The data can then be loaded with the bin/rails db:seed command (or created alongside the database with db:setup).
#
# Examples:
#
#   movies = Movie.create([{ name: "Star Wars" }, { name: "Lord of the Rings" }])
#   Character.create(name: "Luke", movie: movies.first)

# 既存データの削除
Seat.destroy_all
Screen.destroy_all
Price.destroy_all

Price_data = ([
    { ticket_type: "一般", price: 2000},
    { ticket_type: "学生", price: 1500}
  ])
prices_data.each do |data|
  Price.find_or_create_by!(name: data[:name]) do |p|
    p.value = data[:value]
  end
end

theater = Theater.create!(name: "シアタス新宿")

screens_info = [
  { name: "シアター1", size: "large" },
  { name: "シアター2", size: "standard" },
  { name: "シアター3", size: "small" }
]

puts "Creating screens and generating seats based on seat.rb logic..."
screens_info.each do |info|
  screen = Screen.create!(
    info: info[:info],
    theater: theater
    # もし Screen モデルに size カラムがあれば以下も追加
    # size: info[:size] 
  )

  Seat.generate_for_screen(screen, info[:size]) 
  
  puts "  - Created #{info[:name]} (#{info[:size]} size)"
end