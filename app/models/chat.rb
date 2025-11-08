class Chat < ApplicationRecord
  belongs_to :user
  belongs_to :appointment, optional: true

  has_many :messages, dependent: :destroy
end
