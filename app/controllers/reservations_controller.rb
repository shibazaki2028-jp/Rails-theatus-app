class ReservationsController < ApplicationController
    before_action :set_reservation, only: [:show, :edit, :update, :destroy]
    before_action :set_schedule, only: [:new, :create, :edit, :update, :destroy]
    before_action :logged_in?

    def index
        @schedules = Schedule.all
        @reservations = current_account.reservations.order(created_at: :desc)
    end

    def show
        @reservation = Reservation.find(params[:id])
        @schedule = @reservation.schedule
    end

    def new
        @reservation = Reservation.new
        @seats = @schedule.screen.seats.all

        @reservation_details = @reservation.reservation_details.build        
        @prices = Price.all
    end

    def create
        @reservation = Reservation.new(params[:reservation])
        @reservation.account = current_account
        @reservation.schedule = @schedule
        
        if params[:seat_ids].present?
            params[:seat_ids].each do |seat_id|
              price_id = params[:prices][seat_id]
              
              @reservation.reservation_details.build(
                seat_id: seat_id,
                price_id: price_id
              )
            end
        end
        @reservation.reservation_details.each(&:valid?) 

        # 2. その結果を表示する（これでターミナルに原因が出るようになります）
        p "デバッグ: 予約詳細のエラー内容 -> #{@reservation.reservation_details.map { |d| d.errors.full_messages }}"
    
        # 3. 保存を実行
        @reservation.save!

        if @reservation.save
            redirect_to schedule_reservation_path(@schedule, @reservation), notice: "座席の予約が完了しました。"
        else
            @schedule = Schedule.find(params[:reservation][:schedule_id])
            @prices = Price.all
            render "new"
        end
    end

    def edit
        @reservation = current_account.reservations.find(params[:id])
        @schedule = @reservation.schedule
        @seats = @schedule.screen.seats
        @prices = Price.all
    end

    def update
        @reservation = current_account.reservations.find(params[:id])
        @schedule = @reservation.schedule
      
        original_details = @reservation.reservation_details
        original_price_map = original_details.pluck(:price_id).tally # 例: {1=>2, 2=>1} (ID 1が2枚、ID 2が1枚)
        original_count = original_details.count
      
        new_seat_ids = params[:seat_ids] || []
        new_price_map = params[:prices]&.values_at(*new_seat_ids)&.map(&:to_i)&.tally || {}
      
        if new_seat_ids.count != original_count || new_price_map != original_price_map
          flash.now[:alert] = "座席数またはチケットタイプの構成が変更前と一致しません。"
          @seats = @schedule.screen.seats
          @prices = Price.all 
          return render :edit
        end
      
          @reservation.reservation_details.destroy_all
          
        new_seat_ids.each do |seat_id|
          @reservation.reservation_details.build(
          seat_id: seat_id,
          price_id: params[:prices][seat_id]
          )
        end
        @reservation.save!
      
        redirect_to reservation_path(@reservation), notice: "予約内容を変更しました。"
    rescue => e
        flash.now[:alert] = "更新に失敗しました: #{e.message}"
        @seats = @schedule.screen.seats
        @prices = Price.all
        render :edit
    end

    def confirm
        @seat_ids = params[:seat_ids] || []
        @prices = params[:prices] || {}
        @schedule = Schedule.find(params[:schedule_id])

        @selected_seats = Seat.where(id: @seat_ids)
        @selected_prices = Price.where(id: @prices.values)

        @sum_price = @selected_seats.sum do |seat|
            price_id = @prices[seat.id.to_s]
            Price.find(price_id).price
        end
    end

    def set_reservation
        @reservation = Reservation.find(params[:id])
    end

    def set_schedule
        if params[:schedule_id]
            @schedule = Schedule.find(params[:schedule_id])
        elsif @reservation
            @schedule = @reservation.schedule
        end
    end
        
end
