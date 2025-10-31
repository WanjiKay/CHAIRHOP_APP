class Appointment < ApplicationRecord
  belongs_to :user, optional: true

  validate :user_cannot_book_multiple, on: :update

  validates :time, presence: true
  validates :location, presence: true
  validates :stylist_Name, presence: true

  private

  def user_cannot_book_multiple
    if booked && user && user.appointments.where(booked: true).where.not(id: id).exists?
      errors.add(:base, "Honey, you can't sit in two chairs at once!")
    end
  end
end
