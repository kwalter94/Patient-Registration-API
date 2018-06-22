class CreateRoles < ActiveRecord::Migration[5.2]
  def change
    create_table :roles do |t|
      t.string :rolename
      t.datetime :deleted_at, default: nil
      t.timestamps
    end
  end
end
