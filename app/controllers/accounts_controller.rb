class AccountsController < ApplicationController
  def new
    @account = Account.new
  end

  def create
    @account = Account.new(account_params)
    #@account.role = 2
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