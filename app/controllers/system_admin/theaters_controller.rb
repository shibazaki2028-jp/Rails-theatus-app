class SystemAdmin::TheatersController < ApplicationController

    def index
        @theaters = Theater.all
    end

    def show
        @theater = Theater.find(params[:id])
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

end
