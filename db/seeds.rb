# This file should ensure the existence of records required to run the application in every environment (production,
# development, test). The code here should be idempotent so that it can be executed at any point in every environment.
# The data can then be loaded with the bin/rails db:seed command (or created alongside the database with db:setup).
#
# Example:
#
#   ["Action", "Comedy", "Drama", "Horror"].each do |genre_name|
#     MovieGenre.find_or_create_by!(name: genre_name)
#   end
user = User.create!(email: "client@example.com", password:"password")

Appointment.create!(
  time: Time.current + 2.hours,
  location: "Hot Clips",
  stylist_Name: "Tinsley",
  booked: true,
  content: "Wolf cut, icy tips, and style",
  user: user
)

Appointment.create!(
  time: Time.current + 3.hours,
  location: "Brows and Locks Salon",
  stylist_Name: "Chico",
  booked: true,
  content: "Mama said the works, darling! (wash, cut, colour, style, and face)",
  user: user
)
