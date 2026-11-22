require "test_helper"

class ReservationDetailTest < ActiveSupport::TestCase
  setup do
    @account_a = Account.create!(
      user_name: "利用者あ",
      email: "user_a@example.com",
      password: "password123",
      role: :general
    )

    @account_b = Account.create!(
      user_name: "利用者い",
      email: "user_b@example.com",
      password: "password123",
      role: :general
    )

    theater = Theater.create!(
      name: "テスト映画館",
      address: "東京都テスト区1-1-1",
      telephone: "0312345678"
    )

    screen = Screen.create!(theater: theater, info: "small")

    movie = Movie.create!(
      title: "テスト映画",
      category: "1",
      body: "テスト用の映画です。",
      publish: true,
      published_on: Date.current,
      ended_on: Date.current + 30.days,
      screening_time: 120
    )

    @schedule = Schedule.create!(
      movie: movie,
      screen: screen,
      screened_at: 3.days.from_now.change(hour: 12, min: 0)
    )

    @other_schedule = Schedule.create!(
      movie: movie,
      screen: screen,
      screened_at: 3.days.from_now.change(hour: 15, min: 0)
    )

    @price = Price.create!(ticket_type: "一般", price: 1500)
    @seat = screen.seats.order(:id).first

    @reservation_a = Reservation.create!(account: @account_a, schedule: @schedule)
    @reservation_b = Reservation.create!(account: @account_b, schedule: @schedule)
  end

  test "別の上映回のschedule_idを渡しても、親の予約の上映回に揃う" do
    detail = ReservationDetail.create!(
      reservation: @reservation_a,
      seat: @seat,
      price: @price,
      schedule_id: @other_schedule.id
    )

    assert_equal @schedule.id, detail.schedule_id
  end

  test "バリデーションを飛ばしても、DBの一意制約が同じ上映回・同じ座席の2件目を拒否する" do
    ReservationDetail.create!(
      reservation: @reservation_a,
      seat: @seat,
      price: @price
    )

    detail_b = ReservationDetail.new(
      reservation: @reservation_b,
      seat: @seat,
      price: @price,
      schedule_id: @schedule.id
    )

    assert_raises(ActiveRecord::RecordNotUnique) do
      detail_b.save(validate: false)
    end
  end
  
  test "同じ上映回・同じ座席の2件目は、バリデーションで無効になる" do
    ReservationDetail.create!(
      reservation: @reservation_a,
      seat: @seat,
      price: @price
    )

    detail_b = ReservationDetail.new(
      reservation: @reservation_b,
      seat: @seat,
      price: @price
    )
    assert_not detail_b.valid?
    assert_includes detail_b.errors[:seat_id], "は既に予約されています"
  end 

  test "親の予約がない明細は無効になる" do
    detail = ReservationDetail.new(
      seat: @seat,
      price: @price
    )
    assert_not detail.valid?
    assert detail.errors.of_kind?(:reservation, :blank)
  end

  test "保存済みの明細をもう一度バリデーションしても、自分自身とは衝突しない" do
    detail = ReservationDetail.create!(
      reservation: @reservation_a,
      seat: @seat,
      price: @price
    )
    assert detail.valid?
  end
end