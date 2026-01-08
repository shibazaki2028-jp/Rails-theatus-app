class MoviesController < ApplicationController
    before_action :logged_in?

    #一覧表示
    def index 
        @movies = Movie.all
    end

    #詳細表示
    def show 
        @movie = Movie.find(params[:id])

        @schedules = @movie.schedules.order(:screened_at)
    end
end
