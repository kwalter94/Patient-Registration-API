class CreatePrivileges < ActiveRecord::Migration[5.2]
  def change
    create_table :privileges do |t|
      t.string :name
      t.datetime :deleted_at, default: nil
      t.timestamps
    end
  end
end
