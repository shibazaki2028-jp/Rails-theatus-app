class ReservationsController < ApplicationController
    before_action :set_schedule

    def show
        @reservation = Reservation.find(params[:id])
    end

    def new
        @reservation = Reservation.new
        @seats = @schedule.screen.seats.all
    end

    def create
        @reservation = Reservation.new(params[:reservation])
        @reservation.account = Account.first #あとで、ログインしているアカウントを入れるように修正
        @reservation.schedule = @schedule
        
        @reservation.save!
        params[:seat_ids].each do |seat_id|
            @reservation.reservation_details.create!(seat_id: seat_id)
        end

        if @reservation.save
            redirect_to :root#schedule_reservation_path(@schedule, @reservation), notice: "座席の予約が完了しました。"
        else
            render "new"
        end
    end

    def set_schedule
        @schedule = Schedule.find(params[:schedule_id])
    end
        
end
