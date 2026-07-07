class AccountsController < ApplicationController
  before_action :require_login, only: [:show, :edit, :update, :destroy]

  def show
    @account = current_account
  end

  def edit
    @account = current_account
  end

  def update
    @account = current_account
    @account.assign_attributes(account_params)
    if @account.save
      redirect_to :account, notice: "アカウント情報を更新しました。"
    else
      render :edit, status: :unprocessable_entity
    end
  end

  def new
    @account = Account.new
  end

  def create
    @account = Account.new(account_params)
    #一般会員の新規登録はroleの設定は"general"で固定する
    @account.role = :general
    if @account.save
      redirect_to root_path, notice: "アカウントを登録しました"
    else
      render :new, status: :unprocessable_entity 
    end
  end

  def destroy
    #他人のアカウントを削除できないように変更
    current_account.destroy
    cookies.delete(:account_id)
    
    redirect_to :root, notice: "退会しました。"
  end

  def account_params
    params.require(:account).permit(:user_name, :email, :password)
  end
end