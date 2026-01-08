class AccountsController < ApplicationController
  def new
    @account = Account.new
  end

  def create
    @account = Account.new(params[:account])
    @account.role = 2
    if @account.save
      redirect_to root_path, notice: "アカウントを登録しました"
    else
      render "new"
    end
  end
end