class ApplicationController < ActionController::Base
    #before_action :update_expiration_time

    private def current_account
        Account.find_by(id: cookies.signed[:account_id]) if cookies.signed[:account_id]
    end
end
