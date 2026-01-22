class SystemAdmin::ReservationsController < ApplicationController
  before_action :authenticate_system_admin!

  def index
    @account = Account.find(params[:account_id])
    if current_account.theater_admin?
      @reservations = Reservation.joins(schedule: :screen)
                                 .where(screens: { theater_id: current_account.theater.id })
    else
      #システム管理者の場合には、アカウントごとの予約を取得
      @reservations = @account.reservations.order(created_at: :desc)
    end
  end
end