class ChatsController < ApplicationController
  before_action :authenticate_user!

  def index
    @chats = current_user.chats
  end

  def show
    @chat = Chat.find(params[:id])
    unless @chat.user == current_user
      redirect_to chats_path, alert: "You are not authorized to view this chat."
      return
    end
    @messages = @chat.messages.order(created_at: :desc)
    @message = Message.new
  end

  def create
    @chat = Chat.new(chat_params)
    @chat.user = current_user
    @chat.appointment = Appointment.first
    if @chat.save
      redirect_to @chat
    else
      flash.now[:alert] = "Failed to create chat."
      render :new, status: :unprocessable_entity
    end
  end

  def new
    @chat = Chat.new
  end

  private

  def chat_params
    params.require(:chat).permit(:title)
  end
end
