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
end
