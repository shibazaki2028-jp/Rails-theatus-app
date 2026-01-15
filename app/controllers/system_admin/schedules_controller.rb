class SystemAdmin::SchedulesController < ApplicationController
    before_action :authenticate_admin!
    before_action :permit_theater_admin!, only: [:edit, :update, :destroy]

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

    def authorize_theater_admin!
        return if current_account.system_admin?
    
        if current_account.theater != @schedule.screen.theater
          redirect_to system_admin_schedules_path, alert: "他館のスケジュールは操作できません。"
        end
      end

    def schedule_params
        params.require(:schedule).permit(:movie_id, :screen_id, :screened_at)
    end
end