class SystemAdmin::MoviesController < ApplicationController

    #一覧表示
    def index 
        @movies = Movie.all
    end

    #詳細表示
    def show 
        @movie = Movie.find(params[:id])
    end

    #新規登録フォーム
    def new
        @movie = Movie.new
    end

    #新規登録を保存
    def create
        @movie = Movie.new(params[:movie])
        if @movie.save
            redirect_to :root, notice: "映画の登録が完了しました。"
        else
            render "new"
        end
    end

    #更新フォーム
    def edit
        @movie = Movie.find(params[:id])
    end

    #内容を保存
    def update
        @movie = Movie.find(params[:id])
        if @movie.save
            redirect_to :root, notice: "映画の更新が完了しました。"
        else
            render "edit"
        end
    end

    #映画の削除
    def destroy
        @movie = Movie.find(params[:id])
        @movie.destroy
        redirect_to :root, notice: "映画の削除が完了しました。"
    end

end
