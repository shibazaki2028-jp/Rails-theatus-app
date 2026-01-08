# app/controllers/sessions_controller.rb
class SessionsController < ApplicationController
    def new
      @account = Account.new
    end
  
    def create
        account = Account.find_by(user_name: params[:session][:user_name])
        if account&.authenticate(params[:session][:password])
            cookies.signed[:account_id] = {
                value: account.id,
                expires: 1.day.from_now
            }
            redirect_to :root
        else
            flash.alert = "名前とパスワードが一致しません"
            render :new
        end
    end

    def destroy
        cookies.delete(:account_id)
        redirect_to :root
    end
  end