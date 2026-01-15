class AccountsController < ApplicationController
  
  def show
    @account = current_account
  end

  def edit
    @account = current_account
  end

  def update
    @account = current_account
    @account.assign_attributes(params[:account])
    if @account.save
      redirect_to :account, notice: "アカウント情報を更新しました。"
    else
      render "edit"
    end
  end

  def new
    @account = Account.new
  end

  def create
    @account = Account.new(account_params)
    if @account.save
      redirect_to root_path, notice: "アカウントを登録しました"
    else
      render "new"
    end
  end

  def account_params
    params.require(:account).permit(:user_name, :email, :password, :role)
  end
end