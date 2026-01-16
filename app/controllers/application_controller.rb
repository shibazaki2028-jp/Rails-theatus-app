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

    def authenticate_admin!
        unless current_account&.theater_admin? || current_account&.system_admin?
            redirect_to root_path, alert: "管理権限がありません。"
        end
    end
    
    def authenticate_system_admin!
        unless current_account&.system_admin?
            redirect_to root_path, alert: "管理権限がありません。" 
        end
    end

    class LoginRequired < StandardError; end

    rescue_from LoginRequired, with: :handle_login_required

    def handle_login_required
    redirect_to login_path, alert: "権限がないか、ログインが必要です"
    end
end