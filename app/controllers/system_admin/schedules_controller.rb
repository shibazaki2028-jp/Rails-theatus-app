class SystemAdmin::SchedulesController < ApplicationController
    before_action :authenticate_admin!
    before_action :permit_theater_admin!, only: [:edit, :update, :destroy]

    def new
        @schedule = Schedule.new
        extracted_screens
    end

    def index
        if current_account.system_admin?
            @schedules = Schedule.all.includes(:movie, screen: :theater).order(:screened_at)
        else
            @schedules = Schedule.joins(screen: :theater)
            .where(screens: { theater_id: current_account.theater.id })
            .includes(:movie, screen: :theater)
            .order(:screened_at)
        end
        @schedules_by_movie = @schedules.group_by(&:movie)
    end

    def create
        @schedule = Schedule.new(schedule_params)
        if @schedule.save
            redirect_to system_admin_schedules_path, notice: "スケジュールを登録しました"
        else
            extracted_screens
            render :new
        end
    end

    def edit
        @schedule = Schedule.find(params[:id])
    end

    def update
        @schedule = Schedule.find(params[:id])
        @schedule.assign_attributes(params[:schedule])
        if @schedule.save
            redirect_to system_admin_schedules_path, notice: "スケジュールの更新が完了しました。"
        else
            render "edit"
        end
    end

    def destroy
        @schedule = Schedule.find(params[:id])
        @schedule.destroy
        redirect_to system_admin_schedules_path, notice: "スケジュールの削除が完了しました。"
    end

    def show
        @schedule = Schedule.find(params[:id])
        @seats = @schedule.screen.seats.all

        @reserved_details = @schedule.reservation_details.includes(reservation: :account).index_by(&:seat_id)
    end

    def permit_theater_admin!
        return if current_account.system_admin?
        @schedule = Schedule.find(params[:id])
        if current_account.theater != @schedule.screen.theater
          redirect_to system_admin_schedules_path, alert: "他館のスケジュールは操作できません。"
        end
      end

    def schedule_params
        params.require(:schedule).permit(:movie_id, :screen_id, :screened_at)
    end

    def extracted_screens
        if current_account.system_admin?
            @screens = Screen.all
        else
            @screens = current_account.theater.screens
        end
    end
end