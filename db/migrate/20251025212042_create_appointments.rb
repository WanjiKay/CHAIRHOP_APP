class CreateAppointments < ActiveRecord::Migration[7.1]
  def change
    create_table :appointments do |t|
      t.datetime :time, null: false
      t.string :location, null: false
      t.boolean :booked, default: false
      t.text :content
      t.references :user, null: false, foreign_key: true

      t.timestamps
    end
  end
end
