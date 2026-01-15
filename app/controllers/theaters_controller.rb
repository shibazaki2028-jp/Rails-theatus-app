class TheatersController < ApplicationController

    #一覧表示
    def index 
        @theaters = Theater.all
    end

    def search
        @theaters = Theater.search(params[:address])
        #.page(params[:page]).per(15)
        render "index"
    end

    #詳細表示
    def show 
        @theater = Theater.find(params[:id])

        @schedules = @theater.schedules.order(:screened_at)
    end

    private

    def permit_theater_manager
        return if current_account.system_admin?

        manager = current_account.theater_admin? && 
                    current_account.theater&.id == params[:id].to_i

        unless manager
            redirect_to root_path, alert: "担当映画館以外の編集権限がありません。"
        end
    end
end
