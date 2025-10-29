class Message < ApplicationRecord
  belongs_to :chat
  has_many_attached :photos
  validates :content, presence: true
end
