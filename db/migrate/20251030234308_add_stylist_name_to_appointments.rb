class AddStylistNameToAppointments < ActiveRecord::Migration[7.1]
  def change
    add_column :appointments, :stylist_Name, :string
  end
end
