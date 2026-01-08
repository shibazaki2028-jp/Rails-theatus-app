class ApplicationController < ActionController::Base
    #before_action :update_expiration_time
    helper_method :current_account, :logged_in?
    
    private 
    def current_account
        Account.find_by(id: cookies.signed[:account_id]) if cookies.signed[:account_id]
    end

    def logged_in?
        current_account.present?
    end
end
