class Appointment < ApplicationRecord
  belongs_to :user

  validates :user_cannot_book_multiple, on: :update

  def user_cannot_book_multiple
    if booked && user.appointments.where(booked: true).exists?
      errors.add(:base, "Honey, you can't sit in two chairs at once!")
    end
  end
end
