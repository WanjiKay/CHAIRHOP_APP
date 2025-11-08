SYSTEM_PROMPT = "You are an assitant for an booking application. n/n/ The task is to help answer the questions of the customers."
class MessagesController < ApplicationController
  before_action :set_chat

  # def index
  #   @messages = @chat.messages
  # end

  def new
    @message = Message.new
  end

  # def create
  #   @message = Message.new(message_params)
  #   @message.chat = @chat
  #   @message.role = "user"
  #   if @message.save
  #     if @message.photos.attached?
  #       process_file(@message.photos.first)

  #     else
  #     send_question
  #     end
  #     # @ruby_llm_chat = RubyLLM.chat
  #     # response = @ruby_llm_chat.with_instructions(instructions).ask(@message.content)
  #     Message.create(role: "assistant", content: @response.content, chat: @chat)
  #     redirect_to chat_path(@chat)
  #   else
  #     render "chats/show", status: :unprocessable_entity
  #   end

  # end

  def create
    @chat = Chat.find(params[:chat_id])
    @message = Message.new(message_params.merge(role: "user", chat: @chat))
    if @message.valid? # don't call `save` anymore
      .with_instructions(instructions).ask(@message.content)
        next if chunk.content.blank? # skip empty chunks

        message = @chat.messages.last
        message.content += chunk.content
        broadcast_message(message)
      end
      @chat.generate_title_from_first_message if @chat.title == "Untitled"
      message = @chat.messages.last
      broadcast_message(message)
      respond_to do |format|
        format.turbo_stream
        format.html { redirect_to chat_path(@chat) }
      end
    else
      respond_to do |format|
        format.turbo_stream { render turbo_stream: turbo_stream.replace("new_message", partial: "messages/form", locals: { chat: @chat, message: @message }) }
        format.html { render "chats/show", status: :unprocessable_entity }
      end
    end
  end

  private

  def process_file(file)
    if file.image?
      send_question(model: "gpt-4o", with: { image: @message.photos.first.url })
    end
  end

  def send_question(model: "gpt-4.1-nano", with: {})
    @ruby_llm_chat = RubyLLM.chat(model: model)
    @response = @ruby_llm_chat.with_instructions(instructions).ask(@message.content, with: with)
  end

  def set_chat
    @chat = Chat.find(params[:chat_id])
  end

  def message_params
    params.require(:message).permit(:content, photos: [])
  end

  def appointment_context
    appointment = @chat.appointment
    "Here is the context of the appointment: #{appointment.content}, #{appointment.time}, the location is: #{appointment.location}, the stylist's name is: #{appointment.stylist_Name}."
  end

  def instructions
    [SYSTEM_PROMPT, appointment_context]
    .compact.join("\n\n")
  end
end
