class ApplicationController < ActionController::Base
    before_action :update_expiration_time
    helper_method :current_account, :logged_in?
    
    private 
    def current_account
        Account.find_by(id: cookies.signed[:account_id]) if cookies.signed[:account_id]
    end

    def logged_in?
        current_account.present?
    end

    def require_login
        return if logged_in?
        redirect_to new_session_path, alert: "ログインが必要です"
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

    private def update_expiration_time
        if cookies.signed[:account_id].present?
            cookies.signed[:account_id] = {
                value: cookies.signed[:account_id],
                expires: 1.day.from_now
            }
        end
    end
end