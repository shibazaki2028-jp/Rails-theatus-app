class SystemAdmin::ReservationsController < ApplicationController
  def index
    @account = Account.find(params[:account_id])
    @reservations = @account.reservations.order(created_at: :desc)
  end
end