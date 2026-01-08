class ScheduleController < ApplicationController
    
    def index
        @schedules = Schedule.includes(:schedule, :screen).order(screened_at: :asc)
    end

    def show
    end

    def new
        @schedule = Schedule.new
    end

    def create
        @schedule = Schedule.new(schedule_params)
        if @schedule.save
            redirect_to admin_schedules_path, notice: "スケジュールを登録しました"
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
            redirect_to system_admin_screens_path, notice: "スケジュールの更新が完了しました。"
        else
            render "edit"
        end
    end

    def destroy
        @schedule = schedule.find(params[:id])
        @schedule.destroy
        redirect_to system_admin_screens_path, notice: "スケジュールの削除が完了しました。"
    end

end
