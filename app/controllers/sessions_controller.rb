# app/controllers/sessions_controller.rb
class SessionsController < ApplicationController
    def new
      # ログインフォーム表示
    end
  
    def create
        account = Account.find_by(user_name: params[:name])
        if account&.authenticate(params[:password])
            cookies.signed[:account_id] = {
                value: account.id,
                expires: 1.day.from_now
            }
        else
            flash.alert = "名前とパスワードが一致しません"
        end
        redirect_to :root
    end

    def destroy
        cookies.delete(:account_id)
        redirect_to :root
    end
  end