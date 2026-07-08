# This file should contain all the record creation needed to seed the database with its default values.
# The data can then be loaded with the bin/rails db:seed command (or created alongside the database with db:setup).
#
# Examples:
#
#   movies = Movie.create([{ name: "Star Wars" }, { name: "Lord of the Rings" }])
#   Character.create(name: "Luke", movie: movies.first)
puts "== Resetting demo data =="

ReservationDetail.destroy_all
Reservation.destroy_all
Schedule.destroy_all
Seat.destroy_all
Screen.destroy_all
Theater.destroy_all
Movie.destroy_all
Price.destroy_all

puts "== Seeding accounts (general users) =="

hanako = Account.find_or_initialize_by(email: "hanako@example.com")
hanako.assign_attributes(
  user_name: "花子",
  password: "hanako",
  role: :general
)
hanako.save!

admin = Account.find_or_initialize_by(email: "system@example.com")
admin.assign_attributes(
  user_name: "システム管理者",
  password: "admin123",
  role: :system_admin
)
admin.save!

puts "== Seeding theaters and screens =="

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
    published_on: Date.current - 1.year,
    ended_on: Date.current + 1.year,
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
    published_on: Date.current - 2.year,
    ended_on: Date.current + 2.year,
    screening_time: 60,
    publish: false
  },
  {
    title: "あの国へ行こう",
    category: "3",
    body: "うっかり過去に飛んでしまった主人公が巻き起こすドタバタ劇。",
    published_on: Date.current - 1.year,
    ended_on: Date.current + 1.year,
    screening_time: 90,
    publish: true
  },
  {
    title: "アタマ探し",
    category: "1",
    body: "無くなってしまったアタマを探す少女の物語。",
    published_on: Date.current - 4.year,
    ended_on: Date.current + 1.year,
    screening_time: 30,
    publish: true
  },
  {
    title: "カーチェイサー",
    category: "2",
    body: "街を舞台に繰り広げられるノンストップカーチェイス。",
    published_on: Date.current - 3.year,
    ended_on: Date.current + 2.year,
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

base_date = Date.current

schedule_patterns = [
  { time: "09:00", day_offset: -2 },
  { time: "09:00", day_offset: 1 },
  { time: "15:00", day_offset: 1 },
  { time: "19:00", day_offset: 1 }
]

screens.each_with_index do |screen, s_index|
  movie =
    if screen.theater.name.include?("横浜")
      created_movies[3] # アタマ探し
    else
      others = [created_movies[0], created_movies[2]]
      others[s_index % others.length]
    end

  schedule_patterns.each do |pattern|
    start_date = base_date + pattern[:day_offset].days
    start_time = Time.zone.parse("#{start_date} #{pattern[:time]}")
    end_time = start_time + movie.screening_time.minutes + 20.minutes

    Schedule.create!(
      movie: movie,
      screen: screen,
      screened_at: start_time,
      ended_at: end_time
    )
  end
end

kawasaki_station_screen = screens.find do |screen|
  screen.theater.name.include?("川崎駅")
end

if kawasaki_station_screen
  movie = created_movies[4] # カーチェイサー

  car_chaser_patterns = [
    { time: "09:00", day_offset: 2 },
    { time: "09:00", day_offset: 3 },
    { time: "15:00", day_offset: 3 },
    { time: "19:00", day_offset: 3 }
  ]

  car_chaser_patterns.each do |pattern|
    start_date = base_date + pattern[:day_offset].days
    start_time = Time.zone.parse("#{start_date} #{pattern[:time]}")
    end_time = start_time + movie.screening_time.minutes + 20.minutes

    Schedule.create!(
      movie: movie,
      screen: kawasaki_station_screen,
      screened_at: start_time,
      ended_at: end_time
    )
  end
end
puts "== Seeding prices (Master Data) =="

prices_data = [
  { ticket_type: "一般", price: 1500 },
  { ticket_type: "学生", price: 1000 }
]

prices_data.each do |data|
  Price.find_or_create_by!(ticket_type: data[:ticket_type]) do |p|
    p.price = data[:price]
  end
end

puts "== Seeding specific reservation patterns for 'アタマ探し' =="

atama_sagashi = Movie.find_by(title: "アタマ探し")
hanako = Account.find_by(email: "hanako@example.com")
admin = Account.find_by(email: "system@example.com")
general_price = Price.find_by(ticket_type: "一般")

ano_kuni = Movie.find_by(title: "あの国へ行こう")

if ano_kuni
  schedule_15pm = Schedule.where(movie: ano_kuni)
                          .find { |s| s.screened_at.strftime("%H:%M") == "15:00" && s.screened_at > Time.current }
  if schedule_15pm
    res_single = Reservation.create!(account: hanako, schedule: schedule_15pm)
    
    target_seat = schedule_15pm.screen.seats.order(:queue, :verse).first
    if target_seat
      ReservationDetail.create!(
        reservation: res_single,
        seat: target_seat,
        price: general_price,
      )
      puts "Created a single reservation for #{ano_kuni.title} (Seat: #{target_seat.queue}-#{target_seat.verse}) at 15:00"
    end
  end
end

if atama_sagashi
  schedule_9am = Schedule.where(movie: atama_sagashi)
                         .find { |s| s.screened_at.strftime("%H:%M") == "09:00" && s.screened_at > Time.current }

  if schedule_9am
    res_partial = Reservation.create!(account: hanako, schedule: schedule_9am)
    schedule_9am.screen.seats.first(10).each do |seat|
      ReservationDetail.create!(
        reservation: res_partial,
        seat: seat,
        price: general_price,
      )
    end
    puts "Created PARTIAL reservations for #{atama_sagashi.title} at 9:00"
  end

  schedule_19pm = Schedule.where(movie: atama_sagashi)
  .find { |s| s.screened_at.strftime("%H:%M") == "19:00" && s.screened_at > Time.current }

  if schedule_19pm
  res_almost_full = Reservation.create!(account: admin, schedule: schedule_19pm)

  all_seats = schedule_19pm.screen.seats.to_a

  all_seats[0...-1].each do |seat|
  ReservationDetail.create!(
  reservation: res_almost_full,
  seat: seat,
  price: general_price,
  )
  end
  puts "Created ALMOST FULL reservations (1 seat left) for #{atama_sagashi.title} at 19:00"
  end
else
  puts "!! Error: 'アタマ探し' not found. Please check movie seeding."
end