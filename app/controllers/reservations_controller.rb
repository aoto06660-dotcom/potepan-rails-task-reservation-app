class ReservationsController < ApplicationController
  before_action :authenticate_user!

  def new
    @room = Room.find(params[:id])
    @reservation = current_user.reservations.build(room: @room)
  end

  def confirm
    @room = Room.find(params[:room_id])
    @reservation = current_user.reservations.build(reservation_params)
    @reservation.room = @room

    if @reservation.valid?
      render :confirm
    else
      render "rooms/show", status: :unprocessable_entity
    end
  end

  def create
    @room = Room.find(params[:room_id])

    @reservation = current_user.reservations.build(reservation_params)
    @reservation.room = @room

    if @reservation.save
      redirect_to reservations_path, notice: "予約しました"
    else
      render "rooms/show", status: :unprocessable_entity
    end
  end

  def index
    @reservations = current_user.reservations.includes(:room)
  end

  def destroy
    @reservation = current_user.reservations.find(params[:id])

    @reservation.destroy!

    redirect_to reservations_path, notice: "予約を削除しました"
  end


  private

  def reservation_params
    params.require(:reservation).permit(:check_in, :check_out, :guest)
  end

end
