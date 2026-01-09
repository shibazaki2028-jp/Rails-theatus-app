class SystemAdmin::SchedulesController < ApplicationController
    before_action :authenticate_system_admin!

    def new
        @schedule = Schedule.new
    end

    def index
        @schedules = Schedule.all.includes(:movie, screen: :theater).order(:screened_at)
        @schedules_by_movie = @schedules.group_by(&:movie)
    end

    def create
        @schedule = Schedule.new(schedule_params)
        if @schedule.save
            redirect_to system_admin_schedules_path, notice: "スケジュールを登録しました"
        else
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
        @schedule = schedule.find(params[:id])
        @schedule.destroy
        redirect_to system_admin_schedules_path, notice: "スケジュールの削除が完了しました。"
    end

    def schedule_params
        params.require(:schedule).permit(:movie_id, :screen_id, :screened_at)
    end
end