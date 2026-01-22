class SessionsController < ApplicationController
    def new
      @account = Account.new
    end
  
    def create
        account = Account.find_by(email: params[:email])
        if account&.authenticate(params[:password])
            cookies.signed[:account_id] = {
                value: account.id,
                expires: 1.day.from_now
            }
            redirect_to :root, notice: "ログインしました"
        else
            flash.alert = "メールアドレスとパスワードが一致しません"
            render :new
        end
    end

    def destroy
        cookies.delete(:account_id)
        redirect_to :root
    end
  end