class CreateUsers < ActiveRecord::Migration[5.2]
  def change
    create_table :users do |t|
      t.string :username
      t.string :password
      t.boolean :active, :default => false 
      t.integer :person_id
      t.timestamps
    end
  end
end
