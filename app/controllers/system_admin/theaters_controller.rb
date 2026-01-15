class SystemAdmin::TheatersController < ApplicationController
    before_action :authenticate_admin!

    def index
        @theaters = Theater.all
    end

    def show
        @theater = Theater.find(params[:id])
        @schedules = Schedule.where(screen_id: @theater.screen_ids).includes(:movie)
    end

    def new
        @theater = Theater.new
    end

    def create
        @theater = Theater.new(params[:theater])
        if @theater.save
            redirect_to system_admin_theaters_path, notice: "映画館の登録が完了しました。"
        else
            render "new"
        end
    end

    def edit
        @theater = Theater.find(params[:id])

        if current_account.theater_admin? && current_account.theater != @theater
            redirect_to edit_system_admin_theater_path(current_account.theater), alert: "ご自身の劇場の編集画面へ移動しました。"
        end
    end

    def update
        @theater = Theater.find(params[:id])
        @theater.assign_attributes(params[:theater])
        if @theater.save
            redirect_to system_admin_theaters_path, notice: "映画館の更新が完了しました。"
        else
            render "edit"
        end
    end
end
