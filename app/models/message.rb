class Message < ApplicationRecord
  acts_as_message
  belongs_to :chat
  has_many_attached :photos
  # validates :content, presence: true


  # validates :content, length: { minimum: 10, maximum: 1000 }, if: -> { role == "user" }
  # validate :file_size_validation

  # MAX_FILE_SIZE_MB = 10

  # private

  validates :content, length: { minimum: 10, maximum: 1000 }, if: -> { role == "user" }
  validates :role, presence: true
  validates :chat, presence: true
  validate :file_size_validation
  validate :user_message_limit, if: -> { role == "user" }

  scope :visible, -> { where(role: [:user, :assistant]).where.not(content: ["", nil]) }

  after_create_commit :broadcast_append_to_chat
  after_update_commit :broadcast_remove_to_chat

  MAX_FILE_SIZE_MB = 10
  MAX_USER_MESSAGES = 10

  private

  def broadcast_append_to_chat
    return unless role.in?(["user", "assistant"])

    broadcast_append_to chat, target: "messages", partial: "messages/message", locals: { message: self }
  end

  def broadcast_remove_to_chat
    if role == "tool" || content.nil?
      broadcast_remove_to chat, target: "message_#{id}"
    end
  end

  def user_message_limit
    if chat.messages.where(role: "user").count >= MAX_USER_MESSAGES
      errors.add(:base, "You can only send #{MAX_USER_MESSAGES} messages per chat.")
    end
  end


  def file_size_validation
    photos.each do |photo|
      if photo.byte_size > MAX_FILE_SIZE_MB.megabytes
        errors.add(:photos, "size must be less than #{MAX_FILE_SIZE_MB}MB")
      end
    end
  end
end
