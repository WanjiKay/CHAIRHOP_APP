class Chat < ApplicationRecord
  belongs_to :user
  belongs_to :appointment

  has_may :messages
end
