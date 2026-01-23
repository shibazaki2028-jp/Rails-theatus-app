# This file should contain all the record creation needed to seed the database with its default values.
# The data can then be loaded with the bin/rails db:seed command (or created alongside the database with db:setup).
#
# Examples:
#
#   movies = Movie.create([{ name: "Star Wars" }, { name: "Lord of the Rings" }])
#   Character.create(name: "Luke", movie: movies.first)

puts "== Seeding accounts (general users) =="

accounts = [
  {
    user_name: "花子",
    email: "hanako@example.com",
    password: "hanako",
    role: 2
  },
  {
    user_name: "システム管理者",
    email: "system@example.com",
    password: "admin123",
    role: 0
  }
]

accounts.each do |account_data|
  Account.create!(account_data)
end

puts "== Resetting & Seeding theaters =="

Theater.destroy_all 

theaters_data = [
  { name: "シアタス 川崎駅前", address: "神奈川県川崎市川崎区駅前本町3-12", tel: "044-601-8123"},
  { name: "シアタス 川崎多摩区", address: "神奈川県川崎市多摩区登戸新町45-7", tel: "044-945-3378"},
  { name: "シアタス 横浜中華街", address: "神奈川県横浜市中区山下町128-9", tel: "045-228-5640"}
]

screens = []
theaters_data.each do |t_attrs|
  theater = Theater.create!(
    name: t_attrs[:name],
    address: t_attrs[:address],
    telephone: t_attrs[:tel]
  )
  screens << Screen.create!(info: "standard", theater: theater)
end

puts "== Seeding movies =="

movies = [
  {
    title: "あの国へ　-前編-",
    category: "1",
    body: <<~TEXT,
      遠い国へと旅立った少年と少女。
      分断された世界の中で、二人はまだ知らない運命と向き合うことになる。
      物語の始まりを描く前編。
    TEXT
    published_on: Date.new(2026, 1, 1),
    ended_on: Date.new(2026, 2, 28),
    screening_time: 60,
    publish: true
  },
  {
    title: "あの国へ　-後編-",
    category: "1",
    body: <<~TEXT,
      あの国の真実が明らかになり、物語は終局へと向かう。
      選択の先に待つ未来とは――。
      壮大な物語の完結編。
    TEXT
    published_on: Date.new(2026, 3, 1),
    ended_on: Date.new(2026, 4, 30),
    screening_time: 60,
    publish: false
  },
  {
    title: "あの国へ行こう",
    category: "3",
    body: "うっかり過去に飛んでしまった主人公が巻き起こすドタバタ劇。",
    published_on: Date.new(2025, 1, 15),
    ended_on: Date.new(2025, 4, 15),
    screening_time: 90,
    publish: true
  },
  {
    title: "アタマ探し",
    category: "1",
    body: "無くなってしまったアタマを探す少女の物語。",
    published_on: Date.new(2025, 1, 13),
    ended_on: Date.new(2025, 5, 31),
    screening_time: 30,
    publish: true
  },
  {
    title: "カーチェイサー",
    category: "2",
    body: "街を舞台に繰り広げられるノンストップカーチェイス。",
    published_on: Date.new(2025, 1, 5),
    ended_on: Date.new(2025, 6, 30),
    screening_time: 90,
    publish: true
  }
]

created_movies = movies.map do |attrs|
    Movie.find_or_create_by!(title: attrs[:title]) do |movie|
    movie.category       = attrs[:category]
    movie.body           = attrs[:body]
    movie.published_on   = attrs[:published_on]
    movie.ended_on       = attrs[:ended_on]
    movie.screening_time = attrs[:screening_time]
    movie.publish        = attrs[:publish]
  end
end

puts "== Seeding schedules =="

times = ["9:00", "9:00", "15:00", "19:00"]

screens.each_with_index do |screen, s_index|
  if screen.theater.name.include?("横浜")
    movie = created_movies[3]
  else
    others = [created_movies[0], created_movies[2],]
    movie = others[s_index % others.length]
  end

  times.each_with_index do |time_str, t_index|
    start_date = (t_index == 0) ? Date.today : Date.tomorrow
    
    start_time = Time.zone.parse("#{start_date} #{time_str}")
    end_time = start_time + movie.screening_time.minutes + 20.minutes

    Schedule.create!(
      movie: movie,
      screen: screen,
      screened_at: start_time,
      ended_at: end_time
    )
  end
end

screens.each do |screen|
  if screen.theater.name.include?("川崎駅")

    movie = created_movies[4]

    times.each_with_index do |time_str, t_index|
      start_date = (t_index == 0) ? Date.today + 2.days : Date.today + 3.days
      
      start_time = Time.zone.parse("#{start_date} #{time_str}")
      end_time = start_time + movie.screening_time.minutes + 20.minutes

      Schedule.create!(
        movie: movie,
        screen: screen,
        screened_at: start_time,
        ended_at: end_time
      )
    end
  end
end

puts "== Seeding prices (Master Data) =="

prices_data = [
  { ticket_type: "一般", price: 1900 },
  { ticket_type: "学生", price: 1500 }
]

prices_data.each do |data|
  Price.find_or_create_by!(ticket_type: data[:ticket_type]) do |p|
    p.price = data[:price]
  end
end