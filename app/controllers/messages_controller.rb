SYSTEM_PROMPT = "You are an assitant for an booking application. n/n/ The task is to help answer the questions of the customers."
class MessagesController < ApplicationController
  before_action :set_chat

  # def index
  #   @messages = @chat.messages
  # end

  def new
    @message = Message.new
  end

  def create
    @message = Message.new(message_params)
    @message.chat = @chat
    @message.role = "user"
    if @message.save
      if @message.photos.attached?
        process_file(@message.photos.first)

      else
      send_question
      end
      # @ruby_llm_chat = RubyLLM.chat
      # response = @ruby_llm_chat.with_instructions(instructions).ask(@message.content)
      Message.create(role: "assistant", content: @response.content, chat: @chat)
      book_appointment(@message.content)
      redirect_to chat_path(@chat)
    else
      render "chats/show", status: :unprocessable_entity
    end

  end

  # def create
  #   @chat = Chat.find(params[:chat_id])
  #   @message = Message.new(message_params.merge(role: "user", chat: @chat))
  #   if @message.valid? # don't call `save` anymore
  #       @chat.with_instructions(instructions).ask(@message.content)
  #         next if chunk.content.blank? # skip empty chunks

  #         message = @chat.messages.last
  #         message.content += chunk.content
  #         broadcast_message(message)
  #       end

  #       broadcast_replace(@chat.messages.last)


  #       if @chat.messages.where(role:"user").count == 1
  #         @chat.generate_title_from_first_message
  #       end

  #       respond_to do |format|
  #         format.turbo_stream
  #         format.html { redirect_to chat_path(@chat) }
  #       end
  #   else
  #       respond_to do |format|
  #         format.turbo_stream { render turbo_stream: turbo_stream.replace("new_message", partial: "messages/form", locals: { chat: @chat, message: @message }) }
  #         format.html { render "chats/show", status: :unprocessable_entity }
  #       end
  #     end
  # end

  # def create
  #   @chat = Chat.find(params[:chat_id])
  #   @message = Message.new(message_params.merge(role: "user", chat: @chat))

  #   if @message.save
  #     if @message.photos.attached?
  #       process_file(@message.photos.first)
  #    else
  #       send_question(model: "gpt-4.1-nano")
  #     end

  #     # if @message.valid? # don't call `save` anymore
  #     #   # Stream the AI response in chunks
  #     @chat.with_instructions(instructions).ask(@message.content) do |chunk|
  #       next if chunk.content.blank? # skip empty chunks

  #       message = @chat.messages.last
  #       message.content += chunk.content
  #       broadcast_message(message)
  #     end

  #     if @chat.messages.where(role: "user").count == 1
  #       @chat.generate_title_from_first_message
  #     end

  #     respond_to do |format|
  #       format.turbo_stream
  #       format.html { redirect_to chat_path(@chat) }
  #     end

  #   else
  #     respond_to do |format|
  #       format.turbo_stream { render turbo_stream: turbo_stream.replace("new_message", partial: "messages/form", locals: { chat: @chat, message: @message }) }
  #       format.html { render "chats/show", status: :unprocessable_entity }
  #     end
  #   end

  # end



  private

  def book_appointment(message_content)
    appointment = @chat.appointment
    return if appointment.nil?
    content = message_content.downcase

    if content.include?("book") || content.include?("reserve")
      if appointment.booked?
        Message.create(role: "assistant", content: "That appointment is already booked.", chat: @chat)
      else
        appointment.update(booked: true, user:@chat.user)
        Message.create(role: "assistant", content: "✅ You’re all set! I’ve booked your seat at #{appointment.location} with #{appointment.stylist_Name}.", chat: @chat)
      end
    end
  end

  def broadcast_message(message)
    Turbo::StreamsChannel.broadcast_replace_to(@chat, target: helpers.dom_id(message), partial: "messages/message", locals: { message: message })
  end

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
