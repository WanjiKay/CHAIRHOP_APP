# This file should ensure the existence of records required to run the application in every environment (production,
# development, test). The code here should be idempotent so that it can be executed at any point in every environment.
# The data can then be loaded with the bin/rails db:seed command (or created alongside the database with db:setup).
#
# Example:
#
#   ["Action", "Comedy", "Drama", "Horror"].each do |genre_name|
#     MovieGenre.find_or_create_by!(name: genre_name)
#   end
Appointment.destroy_all
User.destroy_all
user = User.create!(email: "client@example.com", password:"password")

Appointment.create!(
  time: Time.current + 2.hours,
  location: "Hot Clips",
  stylist_Name: "Tinsley",
  booked: false,
  content: "Wolf cut, icy tips, and style",
  user: user
)

Appointment.create!(
  time: Time.current + 3.hours,
  location: "Brows and Locks Salon",
  stylist_Name: "Chico",
  booked: false,
  content: "Mama said the works, darling! (wash, cut, colour, style, and face)",
  user: user
)

Appointment.create!(
  time: Time.current + 4.hours,
  location: "Salon Elegance",
  stylist_Name: "Sizzle",
  booked: false,
  content: "kids cut",
  user: user
)



# Find or create a default system user who will own the dummy appointment
general_user = User.first || User.create!(
  email: "general@system.com",
  password: "password123",
  name: "System Bot"
)

# Find or create the dummy appointment used for general (non-booked) chats
Appointment.find_or_create_by!(
  time: Time.current,
  location: "Virtual",
  booked: false,
  content: "This appointment is used for general chats without a specific booking.",
  user_id: general_user.id,
  stylist_Name: "General Chat"
)

puts ":white_check_mark: Dummy appointment 'General Chat' created successfully."
