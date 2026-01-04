class SystemAdmin::ScreensController < ApplicationController
    before_action :set_theater_id

    def index
        @screens = @theater.screens
    end

    def show
        @screen = @theater.screens.find(params[:id])
    end

    def new
        @screen = @theater.screens.new
    end

    def create
        @screen = @theater.screens.new(params[:screen])
        if @screen.save
            redirect_to system_admin_theater_screens_path(@theater), notice: "スクリーンの作成が完了しました。"
        else
            render "new"
        end
    end

    def edit
        @screen = @theater.screens.find(params[:id])
    end

    def update
        @screen = @theater.screens.find(params[:id])
        @screen.assign_attributes(params[:screen])
        if @screen.save
            redirect_to system_admin_theater_screens_path(@theater), notice: "スクリーンの更新が完了しました。"
        else
            render "edit"
        end
    end

    def destroy
        @screen = @theater.screens.find(params[:id])
        @screen.destroy
        redirect_to system_admin_theater_screens_path(@theater), notice: "スクリーンの削除が完了しました。"
    end

    def set_theater_id
        @theater = Theater.find(params[:theater_id])
    end
end
