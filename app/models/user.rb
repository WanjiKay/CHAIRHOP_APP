class User < ApplicationRecord
  # Include default devise modules. Others available are:
  # :confirmable, :lockable, :timeoutable, :trackable and :omniauthable
  devise :database_authenticatable, :registerable,
         :recoverable, :rememberable, :validatable

  has_many :appointments, dependent: :nullify
  has_many :chats
  has_one_attached :avatar

  def avatar_url
    "https://kitt.lewagon.com/placeholder/users/#{id}"
  end
end
