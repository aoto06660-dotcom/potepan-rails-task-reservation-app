class RoomsController < ApplicationController
  before_action :authenticate_user!, except: [:index, :show]

  def index
    if params[:address].present?
      @rooms = Room.where("address LIKE ?", "%#{params[:address]}%")
    else
      @rooms = Room.all
    end
  end

  def show
    @room = Room.find(params[:id])
    @reservation = Reservation.new 
  end

  def new
    @room = current_user.rooms.build
  end

  def create
    @room = current_user.rooms.build(room_params)

    if @room.save
      redirect_to room_path(@room), notice: "施設を登録しました"
    else
      render :new, status: :unprocessable_entity
    end
  end

  def edit
    @room = current_user.rooms.find(params[:id])
  end

  def update
    @room = current_user.rooms.find(params[:id])

    if @room.update(room_params)
      redirect_to room_path(@room), notice: "施設情報を更新しました"
    else
      render :edit, status: :unprocessable_entity
    end
  end

  def destroy
    @room = current_user.rooms.find(params[:id])

    @room.destroy!

    redirect_to rooms_path,
                notice: "施設を削除しました",
                status: :see_other
  end

  def my_rooms
    @rooms = current_user.rooms
  end

  private

  def room_params
    params.require(:room).permit(:name, :bio, :fee, :address, :image)
  end
end
