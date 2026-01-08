class TopController < ApplicationController
    def index
      @movies = Movie.where(publish: true).order(published_on: :desc)
    end
  end