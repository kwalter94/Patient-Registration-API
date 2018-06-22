class CreateRolesUsers < ActiveRecord::Migration[5.2]
  def change
    create_table :roles_users do |t|
      t.integer :role_id
      t.integer :user_id
      t.datetime :deleted_at, default: nil
      t.timestamps
    end
  end
end
