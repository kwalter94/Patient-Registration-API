class CreateUserAuths < ActiveRecord::Migration[5.2]
  def change
    create_table :user_auths do |t|
      t.integer :user_id
      t.string :token
      t.datetime :deleted_at
      t.timestamps
    end
  end
end
