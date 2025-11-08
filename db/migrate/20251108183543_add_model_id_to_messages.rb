class AddModelIdToMessages < ActiveRecord::Migration[7.1]
  def change
    add_column :messages, :model_id, :string
  end
end
