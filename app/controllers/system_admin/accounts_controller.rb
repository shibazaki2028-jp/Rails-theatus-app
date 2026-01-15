class SystemAdmin::AccountsController < ApplicationController
    def index
        @accounts = Account.all
        
    end

    def show
        @account = Account.find(params[:id])
    end

    def new
      @account = Account.new
    end
  
    def create
      @account = Account.new(params[:account])
      if @account.save
        redirect_to root_path, notice: "アカウントを登録しました"
      else
        render "new"
      end
    end
  end