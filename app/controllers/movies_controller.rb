class MoviesController < ApplicationController
    #一覧表示
    def index 
        @movies = Movie.all
    end

    def search
        @movies = Movie.search(params[:title], params[:category], params[:name], params[:publish])
        #.page(params[:page]).per(15)
        render "index"
    end

    #詳細表示
    def show 
        @movie = Movie.find(params[:id])

        @schedules = @movie.schedules.order(:screened_at)
    end
end
