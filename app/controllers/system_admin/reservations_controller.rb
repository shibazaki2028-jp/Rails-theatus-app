class SystemAdmin::ReservationsController < ApplicationController
  def index
    @account = Account.find(params[:account_id])
    if current_account.theater_admin?
      @reservations = Reservation.joins(schedule: :screen)
                                 .where(screens: { theater_id: current_account.theater.id })
    else
      @reservations = Reservation.all
    end
  end
end