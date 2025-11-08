# This file should ensure the existence of records required to run the application in every environment (production,
# development, test). The code here should be idempotent so that it can be executed at any point in every environment.
# The data can then be loaded with the bin/rails db:seed command (or created alongside the database with db:setup).
#
# Example:
#
#   ["Action", "Comedy", "Drama", "Horror"].each do |genre_name|
#     MovieGenre.find_or_create_by!(name: genre_name)
#   end
puts "🌱 Seeding ChairHop data..."

# --- Users ---
# Keep or create your core users
client = User.find_or_create_by!(email: "client@example.com") { |u| u.password = "password" }
system = User.find_or_create_by!(email: "system@chairhop.app") { |u| u.password = "password123"; u.name = "System Bot" }

# Helper: ensure an appointment exists; always attach a user (NOT NULL column)
def ensure_appt!(time:, stylist:, location:, booked:, user:, content: nil)
  appt = Appointment.find_or_initialize_by(time: time, stylist_Name: stylist)
  appt.location = location
  appt.booked   = booked
  appt.user     = user                  # <-- ALWAYS set a user to satisfy NOT NULL
  appt.content  = content if appt.respond_to?(:content)
  appt.save!
  appt
end

SERVICES  = ["Clipper Cut", "Scissor Cut", "Beard Trim", "Color Touch-up", "Blowout"]
STYLISTS  = ["Avery", "Jordan", "Riley", "Casey", "Taylor", "Morgan"]
LOCATIONS = ["Main Salon", "Uptown", "Downtown", "West Side", "East Side"]

now = Time.current

# Clear data in dev if you want a fresh start
if Rails.env.development?
  Appointment.delete_all
end

# Unbooked “open chair” slots — attach to system user (still unbooked)
(0..8).each do |i|
  t = now + i*30.minutes
  ensure_appt!(
    time: t,
    stylist: STYLISTS.sample,
    location: LOCATIONS.sample,
    booked: false,             # open chair
    user: system,              # attach placeholder to satisfy NOT NULL
    content: SERVICES.sample
  )
end

# A few late cancellations (also unbooked, attached to system)
3.times do
  t = now + rand(30..180).minutes
  ensure_appt!(
    time: t,
    stylist: STYLISTS.sample,
    location: LOCATIONS.sample,
    booked: false,
    user: system,              # still required by DB
    content: SERVICES.sample
  )
end

# Some booked ones assigned to real users
[client].each do |u|
  ensure_appt!(
    time: now + rand(5..9).hours,
    stylist: STYLISTS.sample,
    location: LOCATIONS.sample,
    booked: true,
    user: u,
    content: SERVICES.sample
  )
end

puts "✅ Done. Appointments: #{Appointment.count}"
