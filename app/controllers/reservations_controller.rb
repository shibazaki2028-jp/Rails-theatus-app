class ReservationsController < ApplicationController
    before_action :require_login
    before_action :set_reservation, only: [:show, :edit, :update, :destroy]
    before_action :set_schedule, only: [:new, :create, :confirm, :edit, :update]
    before_action :set_prices, only: [:new, :edit, :create, :update]


    def index
        @schedules = Schedule.all
        @reservations = current_account.reservations.order(created_at: :desc)
    end

    def show
        @schedule = @reservation.schedule
    end

    def new
        @reservation = Reservation.new
        @seats = @schedule.screen.seats.all

        @reservation_details = @reservation.reservation_details.build        
    end

    def create
        unless valid_reservation_selection?
            @reservation = Reservation.new(schedule: @schedule)
            return render_new_with_error
        end
        
        @reservation = current_account.reservations.build(schedule: @schedule)

        Reservation.transaction do
            @reservation.save!

            reservation_detail_attributes.each do |attributes|
                @reservation.reservation_details.create!(attributes)
            end
        end

        redirect_to schedule_reservation_path(@schedule, @reservation),
            notice: "座席の予約が完了しました"

    rescue ActiveRecord::RecordInvalid => e
        @reservation = Reservation.new(schedule: @schedule)
        flash.now[:alert] = record_error_message(e.record, "予約に失敗しました")
        render_new_with_error
    end

    def edit
        prepare_edit_form
    end

    def update
        unless valid_reservation_selection?
            prepare_edit_form
            return render :edit, status: :unprocessable_entity
        end

        unless same_ticket_composition?
            flash.now[:alert] = "座席数またはチケットタイプの構成が変更前と一致しません。"
            prepare_edit_form
            return render :edit, status: :unprocessable_entity
        end

        Reservation.transaction do
            @reservation.reservation_details.destroy_all

            reservation_detail_attributes.each do |attributes|
                @reservation.reservation_details.create!(attributes)
            end
        end

        redirect_to reservation_path(@reservation), notice: "予約内容を変更しました。"

    rescue ActiveRecord::RecordInvalid => e
        #transactionのロールバック後にDB上の変更前状態を読み直す
        @reservation.reload

        flash.now[:alert] = record_error_message(e.record, "予約内容の更新に失敗しました")
        prepare_edit_form

        render :edit, status: :unprocessable_entity
    end

    def destroy
        @reservation.destroy
        redirect_to reservations_path, notice: "予約をキャンセルしました"
    end

    def confirm
        unless valid_reservation_selection?
            @reservation = Reservation.new(schedule: @schedule)
            return render_new_with_error
        end

        seats_by_id = @schedule.screen.seats
                               .where(id: @seat_ids)
                               .index_by { |seat| seat.id.to_s }

        @selected_seats = @seat_ids.map { |seat_id| seats_by_id.fetch(seat_id) }
        
        @selected_prices = Price.where(id: @price_ids)
                                .index_by { |price| price.id.to_s }

        @prices = @prices_by_seat
        
        @sum_price = @selected_seats.sum do |seat|
            @selected_prices.fetch(@prices.fetch(seat.id.to_s)).price
        end
    end

    private

    def valid_reservation_selection?
        load_selection_params

        errors = []
        if @seat_ids.empty?
            errors << "座席を1つ以上選択してください"
        end

        if @seat_ids.uniq.length != @seat_ids.length
            errors << "同じ座席を複数選択できません"
        end

        valid_seat_ids = @schedule.screen.seats
                                  .where(id: @seat_ids)
                                  .pluck(:id)
                                  .map(&:to_s)
        if (@seat_ids.uniq - valid_seat_ids).any?
            errors << "スクリーンに存在しない座席が含まれています"
        end
        
        missing_price_seat_ids = @seat_ids.select do |seat_id|
            @prices_by_seat[seat_id].blank?
        end

        if missing_price_seat_ids.any?
            errors << "全ての座席の料金種別を指定してください"
        end

        valid_price_ids = Price.where(id: @price_ids).pluck(:id).map(&:to_s)

        if (@price_ids.uniq - valid_price_ids).any?
            errors << "存在しない料金種別が含まれています"
        end

        if errors.any?
            flash.now[:alert] = errors.join(" ")
            return false
        end

        true
    end

    def load_selection_params
        @seat_ids = Array(params[:seat_ids]).reject(&:blank?).map(&:to_s)

        @prices_by_seat = 
        if params[:prices].present?
            params[:prices].to_unsafe_h.stringify_keys
        else
            {}
        end

        @price_ids = @seat_ids
                        .map { |seat_id| @prices_by_seat[seat_id] }
                        .reject(&:blank?)
    end

    def reservation_detail_attributes
        @seat_ids.map do |seat_id|
            {
                seat_id: seat_id,
                price_id: @prices_by_seat.fetch(seat_id)
            }
        end
    end

    def same_ticket_composition?
        original_price_ids = @reservation.reservation_details
                                         .pluck(:price_id)
                                         .sort
        selected_price_ids = @price_ids.map(&:to_i).sort
        
        @seat_ids.length == @reservation.reservation_details.count &&
            selected_price_ids == original_price_ids
    end

    def prepare_edit_form
        @seats = @schedule.screen.seats.order(:queue, :verse)
        @current_seat_ids = @reservation.reservation_details.pluck(:seat_id)

        @other_reserved_seat_ids = @schedule.reservation_details
                                            .where.not(reservation_id: @reservation.id)
                                            .pluck(:seat_id)
    end

    def record_error_message(record, prefix)
        details = record.errors.full_messages

        if details.any?
            "#{prefix}: #{details.join(', ')}"
        else
            prefix
        end
    end

    def render_new_with_error
        @prices = Price.all
        @seats = @schedule.screen.seats.order(:queue, :verse)
        render "new", status: :unprocessable_entity
    end

    def set_reservation
        #予約の取得方法を統一する。
        @reservation = 
            if current_account.system_admin?
                Reservation.find(params[:id])
            else
                current_account.reservations.find(params[:id])
            end
        rescue ActiveRecord::RecordNotFound
            redirect_to reservations_path, alert: "予約が見つからないか、権限がありません"
        end
    end

    def set_schedule
        if params[:schedule_id]
            @schedule = Schedule.find(params[:schedule_id])
        elsif @reservation
            @schedule = @reservation.schedule
        end
    end

    def set_prices
        @prices = Price.all
    end
        