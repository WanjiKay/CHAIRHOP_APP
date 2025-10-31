SYSTEM_PROMPT = "You are an assitant for an booking application. n/n/ The task is to help answer the questions of the customers."
class MessagesController < ApplicationController

  def index
    @chat = Chat.find(params[:chat_id])
    @messages = @chat.messages
  end

  def new
    @chat = Chat.find(params[:chat_id])
    @message = Message.new
  end

  def create
    @chat = Chat.find(params[:chat_id])
    @message = Message.new(role: "user", content: params[:message][:content], chat:@chat)
    if @message.save
      @ruby_llm_chat = RubyLLM.chat
      response = @ruby_llm_chat.with_instructions(instructions).ask(@message.content)
      Message.create(role: "assistant", content: response.content, chat: @chat)
      redirect_to chat_messages_path(@chat)
    else
      render :new, status: :unprocessable_entity
    end
  end

  private

  def appointment_context
    appointment = @chat.appointment
    "Here is the context of the appointment: #{appointment.content}, #{appointment.time}, #{appointment.location}."
  end

  def instructions
    [SYSTEM_PROMPT, appointment_context]
    .compact.join("\n\n")
  end
end

user= User.create!(email: "client@example.com", password: "password")
