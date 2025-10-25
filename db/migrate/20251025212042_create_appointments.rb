class CreateAppointments < ActiveRecord::Migration[7.1]
  def change
    create_table :appointments do |t|
      t.text :content
      t.string :location
      t.string :booking_status
      t.integer :time
      t.date :date
      t.references :user, null: false, foreign_key: true

      t.timestamps
    end
  end
end
