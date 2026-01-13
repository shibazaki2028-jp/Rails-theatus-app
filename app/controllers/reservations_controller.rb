class ReservationsController < ApplicationController
    before_action :set_schedule, only: [:edit, :update, :destroy, :new, :create]
    before_action :logged_in?

    def index
        @schedules = Schedule.all
        @reservations = current_account.reservations
    end

    def show
        @reservation = Reservation.find(params[:id])
        @schedule = Schedule.find(params[:id])
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

        @reservation.save!
        params[:seat_ids].each do |seat_id|
            @reservation.reservation_details.create!(seat_id: seat_id)
        end

        if @reservation.save
            redirect_to :root#schedule_reservation_path(@schedule, @reservation), notice: "座席の予約が完了しました。"
        else
            @schedule = Schedule.find(params[:reservation][:schedule_id])
            @prices = Price.all
            render "new"
        end
    end

    def set_schedule
        @schedule = Schedule.find(params[:schedule_id])
    end
        
end
