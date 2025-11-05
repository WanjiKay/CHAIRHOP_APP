class Chat < ApplicationRecord
  belongs_to :user
  belongs_to :appointment

  has_many :messages, dependent: :destroy
end
