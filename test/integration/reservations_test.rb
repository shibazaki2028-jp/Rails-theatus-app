require "test_helper"

class ReservationsTest < ActionDispatch::IntegrationTest
  setup do
    @password = "password123"

    @account_a = Account.create!(
      user_name: "利用者あ",
      email: "user_a@example.com",
      password: @password,
      role: :general
    )

    @account_b = Account.create!(
      user_name: "利用者い",
      email: "user_b@example.com",
      password: @password,
      role: :general
    )

    @theater = Theater.create!(
      name: "テスト映画館",
      address: "東京都テスト区1-1-1",
      telephone: "0312345678"
    )

    @screen = Screen.create!(
      theater: @theater,
      info: "small"
    )

    @other_screen = Screen.create!(
      theater: @theater,
      info: "small"
    )

    @movie = Movie.create!(
      title: "テスト映画",
      category: "1",
      body: "テスト用の映画です。",
      publish: true,
      published_on: Date.current,
      ended_on: Date.current + 30.days,
      screening_time: 120
    )

    @schedule = Schedule.create!(
      movie: @movie,
      screen: @screen,
      screened_at: 3.days.from_now.change(hour: 12, min: 0)
    )

    @price = Price.create!(
      ticket_type: "一般",
      price: 1500
    )

    @seat_a = @screen.seats.order(:id).first
    @seat_b = @screen.seats.order(:id).second
    @other_screen_seat = @other_screen.seats.order(:id).first

    @account_a_reservation = Reservation.create!(
      account: @account_a,
      schedule: @schedule
    )

    ReservationDetail.create!(
      reservation: @account_a_reservation,
      seat: @seat_a,
      price: @price
    )

    @account_b_reservation = Reservation.create!(
      account: @account_b,
      schedule: @schedule
    )

    ReservationDetail.create!(
      reservation: @account_b_reservation,
      seat: @seat_b,
      price: @price
    )
  end

  test "未ログインでは予約一覧にアクセスできない" do
    get reservations_path

    assert_redirected_to new_session_path
  end

  test "他人の予約詳細にはアクセスできない" do
    login_as(@account_b)

    get reservation_path(@account_a_reservation)

    assert_redirected_to reservations_path
  end

  test "別スクリーンの座席IDでは予約を作成できない" do
    login_as(@account_b)

    reservation_count = Reservation.count
    detail_count = ReservationDetail.count

    post schedule_reservations_path(@schedule), params: {
      seat_ids: [@other_screen_seat.id.to_s],
      prices: {
        @other_screen_seat.id.to_s => @price.id.to_s
      }
    }

    assert_response :unprocessable_entity
    assert_equal reservation_count, Reservation.count
    assert_equal detail_count, ReservationDetail.count
    assert_match "スクリーンに存在しない座席", response.body
  end

  test "予約更新に失敗しても変更前の座席は残る" do
    login_as(@account_b)

    patch reservation_path(@account_b_reservation), params: {
      seat_ids: [@seat_a.id.to_s],
      prices: {
        @seat_a.id.to_s => @price.id.to_s
      }
    }

    assert_response :unprocessable_entity

    actual_seat_ids = @account_b_reservation
                        .reload
                        .reservation_details
                        .pluck(:seat_id)

    assert_equal [@seat_b.id], actual_seat_ids
  end

  private

  def login_as(account)
    post session_path, params: {
      email: account.email,
      password: @password
    }

    assert_redirected_to root_path
  end
end