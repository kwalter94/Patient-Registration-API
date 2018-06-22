class CreateRolePrivileges < ActiveRecord::Migration[5.2]
  def change
    create_join_table :roles, :privileges do |t|
      t.index :role_id
      t.index :privilege_id

      t.timestamps
    end
  end
end
