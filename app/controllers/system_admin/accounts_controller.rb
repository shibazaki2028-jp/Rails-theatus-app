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
    
    def edit
      @account = Account.find(params[:id])
    end

    def update
      @account = Account.find(params[:id])
      @account.assign_attributes(params[:account])
      if @account.save
        redirect_to system_admin_account_path(@account), notice: "アカウント情報を更新しました。"
      else
        render "edit"
      end
    end

    def destroy
      @account = Account.find(params[:id])
      @account.destroy
      redirect_to system_admin_accounts_path, notice: "会員を削除しました。"
    end


  end