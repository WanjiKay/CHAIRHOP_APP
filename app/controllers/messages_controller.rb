SYSTEM_PROMPT = "You are an assitant for an booking application. n/n/ The task is to help answer the questions of the customers."
class MessagesController < ApplicationController
  before_action :set_chat

  def index
    @messages = @chat.messages
  end

  def new
    @message = Message.new
  end

  def create
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

  def set_chat
    @chat = Chat.find(params[:chat_id])
  end

  def message_params
    params.require(:message).permit(:content, photos: [])
  end

  def chat_context
  "Here is the context of the chat: #{@chat.content}."
  end

  def instructions
  [SYSTEM_PROMPT, chat_context]
  .compact.join("\n\n")
  end
end
