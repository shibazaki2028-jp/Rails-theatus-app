class SystemAdmin::AccountsController < ApplicationController
    before_action :authenticate_system_admin!

    def index
        @accounts = Account.all
        
    end

    def show
        @account = Account.find(params[:id])
    end

    def new
      @account = Account.new

      @account.build_administrator
    end
  
    def create
      @account = Account.new(account_params)
      if @account.save
        redirect_to root_path, notice: "アカウントを登録しました"
      else
        render "new"
      end
    end
    
    def edit
      @account = Account.find(params[:id])

      @account.build_administrator unless @account.administrator
    end

    def update
      @account = Account.find(params[:id])
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

    def account_params
      params.require(:account).permit(
        :user_name, :email, :password, :role,
        administrator_attributes: [:id, :theater_id]
      )
    end

  end