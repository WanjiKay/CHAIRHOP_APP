class Message < ApplicationRecord
  belongs_to :chat
  has_many_attached :photos
  validates :content, presence: true


  validates :content, length: { minimum: 10, maximum: 1000 }, if: -> { role == "user" }
  validate :file_size_validation

  MAX_FILE_SIZE_MB = 10

  private

  def file_size_validation
    photos.each do |photo|
      if photo.byte_size > MAX_FILE_SIZE_MB.megabytes
        errors.add(:photos, "size must be less than #{MAX_FILE_SIZE_MB}MB")
      end
    end
  end
end
