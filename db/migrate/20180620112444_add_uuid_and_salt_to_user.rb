class AddUuidAndSaltToUser < ActiveRecord::Migration[5.2]
  def change
    add_column :users, :salt, :string
    add_column :users, :uuid, :string
  end
end
