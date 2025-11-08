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
    appointment_id = params.dig(:chat, :appointment_id) || params[:appointment_id]
    if appointment_id.present?
      @appointment = Appointment.find(appointment_id)
    else
      @appointment = Appointment.find_by(stylist_Name: "General Chat")
    end
    @chat = Chat.new(chat_params)
    @chat.user = current_user
    @chat.appointment = @appointment
    if @chat.save
      redirect_to @chat
    else
      flash.now[:alert] = "Failed to create chat."
      render :new, status: :unprocessable_entity
    end
  end

  def new
    @chat = Chat.new
    if params[:appointment_id].present?
      @appointment = Appointment.find(params[:appointment_id])
    else
      @appointment = nil
    end
  end

  private

  def chat_params
    params.require(:chat).permit(:title)
  end
end
